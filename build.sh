#!/bin/bash

set -e

version="0.1.0"
db_version="v1.1.0-beta.2"
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
