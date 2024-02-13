#! /usr/bin/env bash

set -e
version="0.1.0"
publish=true

# db
db_url="http://localhost:8000"
db_file="data/surdb.db"
db_version="v1.2.0"

# podman
platforms=("linux/arm64" "linux/amd64")

main() {
  echo -e "\tinit container"
  init_container

  echo -e "\tinjecting data"
  cd src
  for folder in */; do
    local ns=${folder%/}

    inject $ns "main"
  done 
  cd ..

  echo -e "\tfinish container"
  finish_container

  echo -e "\tcreate images"
  create_images

  echo -e "\tclean up"
  clean_up
}

inject() {
  local ns=$1
  local db=$2
  local file="${ns}/dump.surql"

  if [ -f "$file" ]; then
    curl -sS -X 'POST' -H 'Accept: application/json' -H "NS: $ns" -H "DB: $db" --data-binary @"$file" "$db_url/import" | jq '.[] | .status + " " + .time'
  else
    echo -e "\033[0;31mFile not found:\033[0m $file"
  fi
}

init_container() {
  # clean up
  rm -fr ./data
  mkdir ./data
  chmod -R 777 ./data

  # init surrealdb with a volume
  podman run -d --rm \
    --user 1000:1000 \
    --name surrealdb \
    -v ./data:/data \
    -p 8000:8000 \
    "surrealdb/surrealdb:$db_version" \
    start --user root --pass root "file://$db_file"

    # surrealdb/surrealdb:nightly \

  while ! curl -s "$db_url/status" &> /dev/null; do
      echo "Waiting for surrealdb to start..."
      sleep 1
  done
}

finish_container() {
  # remove platform users: viewer, editor, admin
  # should be already resolved but just in case
  curl -sS -X POST \
    -u "root:root" \
    -H "NS: main" \
    -H "Accept: application/json" \
    -d "REMOVE USER root ON ROOT" \
    "$db_url/sql" | jq '.[] | .status + " " + .time'

  # finish the instance
  podman kill surrealdb

  # make sure the data is accessible
  podman run --rm -it --user 1000:1000 -v ./data:/data alpine:3.18 ash -c "chmod -R 777 /data/*"
}

create_images() {
  for platform in ${platforms[@]}; do
    echo "Building docker image for: $platform."

    # get the tag
    local tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})

    # build the image
    podman build --pull --no-cache --platform ${platform} -t kennycallado/surreal:${version}-${tag} -f Containerfile .

    if [ $publish == true ]; then
      podman push kennycallado/surreal:${version}-${tag}
    fi
  done

  if [ $publish == true ]; then
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
      local tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})
      podman manifest add --arch ${tag} kennycallado/surreal:latest kennycallado/surreal:${version}-${tag}

      podman manifest add --arch ${platform#*/} kennycallado/surreal:latest kennycallado/surreal:${version}-${tag}
    done

    echo "Pushing the manifests..."
    # and remove them
    podman manifest push --rm kennycallado/surreal:$version docker://kennycallado/surreal:$version
    podman manifest push --rm kennycallado/surreal:latest docker://kennycallado/surreal:latest
  fi
}

clean_up() {
  echo "Removing the images..."
  for platform in ${platforms[@]}; do
    local tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})

    podman rmi kennycallado/surreal:${version}-${tag}
  done

  echo "Cleaning up the manifest..."
  podman system prune -f
  rm -fr ./data
}

main "$@"

cd "$pwd"
exit 0
