#! /usr/bin/env bash
#
# WARNING: take care of the Containerfile image version

set -e
name="q-api-store"
version=$(git describe --tags --abbrev=0)
# version="v0.2.6"
testing=true
latest=true
publish=false
remove_images=true

# db
db_url="http://localhost:8000"
db_file="data/surdb.db"
db_version="v1.5.0"

# podman
platforms=("linux/arm64" "linux/amd64")

main() {
  echo -e "\tinit container\n"
  init_container $1

  echo -e "\tinjecting data\n"
  ./init.sh

  # inject demo example
  if [ "$1" == "true" ]; then
    echo -e "\tcreating demo image"
    name="${name}-demo"

    echo -e "\tinjecting demo"
    ./seed.sh "demo"

    podman logs super

    echo -e "\t test demo"
    count=$(curl -sS -X POST \
      -u "root:root" \
      -H "NS: demo" \
      -H "DB: demo" \
      -H "Accept: application/json" \
      -d "SELECT count() FROM papers GROUP BY count;" \
      "localhost:8000/sql")

    count=$(echo $count | jq '.[] | .result | .[] | .count')

    echo "Are there some papers?"
    echo "->> $count"
    echo "     🔼"

    c_users=$(curl -sS -X POST \
      -u "root:root" \
      -H "NS: global" \
      -H "DB: main" \
      -H "Accept: application/json" \
      -d "SELECT count() FROM users GROUP BY count;" \
      "localhost:8000/sql")

    c_users=$(echo $c_users | jq '.[] | .result | .[] | .count')
    echo 
    echo "How many users are there?"
    echo "->> $c_users"
    echo "     🔼"

    join=$(curl -sS -X POST \
      -u "root:root" \
      -H "NS: global" \
      -H "DB: main" \
      -H "Accept: application/json" \
      -d "SELECT count() FROM join GROUP BY count;" \
      "localhost:8000/sql")

    join=$(echo $join | jq '.[] | .result | .[] | .count')
    echo 
    echo "How many joins are there?"
    echo "->> $join"
    echo "     🔼"

    thera=$(curl -sS -X POST \
      -u "root:root" \
      -H "NS: global" \
      -H "DB: main" \
      -H "Accept: application/json" \
      -d "SELECT count() FROM users WHERE username = 'thera' GROUP BY count;" \
      "localhost:8000/sql")

    thera=$(echo $thera | jq '.[] | .result | .[] | .count')
    echo 
    echo "Is there a user called thera?"
    echo "->> $thera"
    echo "     🔼"

    sleep 1

    podman logs super
    sleep 1

    if [ $testing == true ]; then
      finish_container
      clean_up
      exit 0
    fi
  fi

  echo -e "\tfinish container"
  finish_container

  echo -e "\tremoving previous images\n"
  remove_previous_images

  echo -e "\tcreate images"
  create_images

  echo -e "\tclean up"
  clean_up
}

inject() {
  local ns=$1
  local db=$2
  local file="$ns/$db/dump.surql"

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

  podman pod create --name foo -v ./data:/data -v ./data:/tmp -p 8000:8000

  podman run -d \
    --name surrealdb \
    --pod foo \
    --user 1000:1000 \
    "surrealdb/surrealdb:$db_version" \
    start --no-banner -A --user root --pass root "file://$db_file"

  while ! curl -s "$db_url/status" &> /dev/null; do
      echo "Waiting for surrealdb to start..."
      sleep 1
  done

  if [ "$1" == "true" ]; then
    podman run -d \
      --name super \
      --pod foo \
      --user 1000:1000 \
      "kennycallado/q-api-super:latest"
  fi

  echo "Waiting for super to start..."
  sleep 5
}

finish_container() {
  # remove platform users: viewer, editor, admin
  # should be already resolved but just in case
  curl -sS -X POST \
    -u "root:root" \
    -H "NS: global" \
    -H "Accept: application/json" \
    -d "REMOVE USER root ON ROOT" \
    "$db_url/sql" | jq '.[] | .status + " " + .time'

  podman pod stop foo
  podman pod rm foo

  # make sure the data is accessible
  podman run --rm -it --user 1000:1000 -v ./data:/data alpine:3.18 ash -c "chmod -R 777 /data/*"
}

remove_previous_images() {
  echo "Removing previous images..."
  for platform in ${platforms[@]}; do
    local tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})

    podman rmi kennycallado/${name}:${version}-${tag} &> /dev/null || true
  done

  podman rmi kennycallado/${name}:$version &> /dev/null || true
  podman rmi kennycallado/${name}:latest &> /dev/null || true
}

create_images() {
  for platform in ${platforms[@]}; do
    echo "Building docker image for: $platform."

    # get the tag
    local tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})

    # build the image
    podman build --pull --no-cache --platform ${platform} -t kennycallado/${name}:${version}-${tag} --build-arg version=${db_version} -f Containerfile .

    if [ $publish == true ]; then
      podman push kennycallado/${name}:${version}-${tag}
    fi
  done

  if [ $publish == true ]; then
    echo "Creating the manifest version: $version"
    podman manifest create kennycallado/${name}:$version
    for platform in ${platforms[@]}; do
      tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})
      podman manifest add --arch ${tag} kennycallado/${name}:${version} kennycallado/${name}:${version}-${tag}

      podman manifest add --arch ${platform#*/} kennycallado/${name}:${version} kennycallado/${name}:${version}-${tag}
    done

    if [ $latest == true ]; then
      echo "Createing the latest manifest"
      podman manifest create kennycallado/${name}:latest
      for platform in ${platforms[@]}; do
        local tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})
        podman manifest add --arch ${tag} kennycallado/${name}:latest kennycallado/${name}:${version}-${tag}

        podman manifest add --arch ${platform#*/} kennycallado/${name}:latest kennycallado/${name}:${version}-${tag}
      done
    fi

    echo "Pushing the manifests..."
    # and remove them
    podman manifest push --rm kennycallado/${name}:$version docker://kennycallado/${name}:$version
    podman manifest push --rm kennycallado/${name}:latest docker://kennycallado/${name}:latest
  fi
}

clean_up() {
  if [ remove_images == true ]; then
    echo "Removing the images..."
    for platform in ${platforms[@]}; do
      local tag=$(echo "${platform//\//_}" | tr -d 'linux_' | xargs -I {} echo {})

      podman rmi kennycallado/${name}:${version}-${tag}
    done
  fi

  echo "Cleaning up the manifest..."
  podman system prune -f
  rm -fr ./data
}

main "$@"

cd "$pwd"
exit 0
