#!/bin/bash

set -e

version="0.1.0"

# clean up
rm -rf ./data
mkdir ./data
chmod -R 777 ./data

# init surrealdb with a volume
podman run -d --rm \
  --user 1000:1000 \
  --name surrealdb \
  -v ./data:/data \
  -p 8000:8000 \
  surrealdb/surrealdb:nightly \
  start --user root --pass root file://data/surdb.db

  # surrealdb/surrealdb:1.0.0 \

while ! curl -s http://localhost:8000/status &> /dev/null; do
    echo "Waiting for surrealdb to start..."
    sleep 1
done

# import the data
cat ./src/content/dump.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: main' -H 'DB: content' --data-binary @- http://localhost:8000/import &> /dev/null
cat ./src/outcome/dump.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: main' -H 'DB: outcome' --data-binary @- http://localhost:8000/import &> /dev/null
cat ./src/project/dump.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: main' -H 'DB: project' --data-binary @- http://localhost:8000/import &> /dev/null

# remove platform users: viewer, editor, admin
# should be already resolved but just in case
curl -sS -X POST \
  -u "root:root" \
  -H "NS: main" \
  -H "Accept: application/json" \
  -d "REMOVE USER admin   ON NS;
      REMOVE USER viewer  ON NS;
      REMOVE USER root    ON ROOT" \
  http://localhost:8000/sql | jq '.[] | .status + " " + .time'

# finish the instance
podman kill surrealdb

# make sure the data is accessible
podman run --rm -it --user 1000:1000 -v ./data:/data alpine:3.18 ash -c "chmod -R 777 /data/*"

platforms=("linux/amd64" "linux/arm64")
for platform in ${platforms[@]}; do
  echo "Building docker image for: $platform."

  # get the tag
  tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})

  # build the image
  podman build --platform ${platform} -t kennycallado/surreal:${version}-${tag} -f Containerfile .
  podman push kennycallado/surreal:${version}-${tag}
done

echo "Creating the manifest version: $version"
podman manifest create kennycallado/surreal:$version
for platform in ${platforms[@]}; do
  tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})
  podman manifest add --arch ${tag} kennycallado/surreal:$version kennycallado/surreal:${version}-${tag}

  podman manifest add --arch ${platform#*/} kennycallado/surreal:${version} kennycallado/surreal:${version}-${tag}
done

echo "Createing the latest manifest"
podman manifest create kennycallado/surreal:latest
for platform in ${platforms[@]}; do
  tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})
  podman manifest add --arch ${tag} kennycallado/surreal:latest kennycallado/surreal:${version}-${tag}

  podman manifest add --arch ${platform#*/} kennycallado/surreal:latest kennycallado/surreal:${version}-${tag}
done

echo "Pushing the manifests..."
podman manifest push --rm kennycallado/surreal:$version docker://kennycallado/surreal:$version
podman manifest push --rm kennycallado/surreal:latest docker://kennycallado/surreal:latest

echo "Removing the images..."
for platform in ${platforms[@]}; do
  tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})
  podman rmi kennycallado/surreal:${version}-${tag}
done

echo "Cleaning up the manifest..."
podman system prune -f

rm -rf ./data

exit 0
