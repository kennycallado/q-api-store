#!/bin/bash

set -e

version="0.1.0"

# clean up
rm -rf ./data
mkdir ./data

# init surrealdb with a volume
# surrealdb/surrealdb:1.0.0 \
docker run -d --rm \
  --user 1000:1000 \
  --name surrealdb \
  -v ./data:/data \
  -p 8000:8000 \
  surrealdb/surrealdb:nightly \
  start --user root --pass root file://data/surdb.db

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
docker kill surrealdb

# make sure the data is accessible
chmod -R 777 ./data

platforms=("linux/amd64" "linux/arm64")
for platform in ${platforms[@]}; do
  echo "Building docker image for: $platform."

  # get the tag
  tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})

  # build the image
  docker build --platform ${platform} -t kennycallado/surreal:${version}-${tag} -f Containerfile .
done

rm -rf ./data

# docker push -a kennycallado/surreal
# docker rmi 
# docker system prune -f
