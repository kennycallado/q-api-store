#!/bin/bash

set -e

# clean up
rm -rf ./data
mkdir ./data

# init surrealdb with a volume
docker run -d --rm \
  --user 1000:1000 \
  --name surrealdb \
  -v ./data:/data \
  -p 8000:8000 \
  surrealdb/surrealdb:1.0.0 \
  start --user root --pass root file://data/surdb.db

while ! curl -s http://localhost:8000/status &> /dev/null; do
    echo "Waiting for surrealdb to start..."
    sleep 1
done

# import the data
cat ./src/content/dump.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: test' -H 'DB: content' --data-binary @- http://localhost:8000/import &> /dev/null
cat ./src/outcome/dump.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: test' -H 'DB: outcome'    --data-binary @- http://localhost:8000/import &> /dev/null

# remove platform users: viewer, editor, admin
curl -sS -X POST \
  -u "root:root" \
  -H "NS: test" \
  -H "Accept: application/json" \
  -d "REMOVE USER admin ON NS;
      USE DB content;
      REMOVE USER viewer ON DB;
      USE DB outcome;
      REMOVE USER viewer ON DB;
      REMOVE USER root ON ROOT" \
  http://localhost:8000/sql | jq '.[].status'

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
  docker build --platform ${platform} -t kennycallado/surreal:${tag} -f Containerfile .
done

# docker push -a kennycallado/surreal
# docker rmi 
# docker system prune -f
