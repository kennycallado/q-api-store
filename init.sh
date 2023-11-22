#!/bin/bash

set -e

cat ./base/create.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: test' --data-binary @- http://localhost:8000/import &> /dev/null

layers=("content" "outcome")
entities=( \
  "content/base" \
  "content/locales" \
  "content/media" \
  "content/questions" \
  "content/slides" \
  "content/resources" \
  "outcome/base" \
  "outcome/answers" \
  "outcome/papers" \
  "outcome/scores" \
  "outcome/scripts" \
)

# inject the data
for entity in ${entities[@]}; do

  if [[ "$entity" == *"content"* ]]; then
    db="content"
  else if [[ "$entity" == *"outcome"* ]]; then
    db="outcome"
  fi
  fi

  pwd=$(pwd)
  cd src/$entity

  if [ -f "./define.surql" ]; then
    printf "\nDefinning $entity...\n"
    cat ./define.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: test' -H 'DB: '$db --data-binary @- http://localhost:8000/import
  fi

  if [ -f "./create.surql" ]; then
    printf "\nCreating $entity...\n"
    cat ./create.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: test' -H 'DB: '$db --data-binary @- http://localhost:8000/import
  fi

  cd $pwd
done

# export the data
for layer in ${layers[@]} ;do

  if [[ "$layer" == *"content"* ]]; then
    db="content"
  else if [[ "$layer" == *"outcome"* ]]; then
    db="outcome"
  fi
  fi

  pwd=$(pwd)
  cd src/$layer
  printf "\nExporting $layer...\n"
  curl -sS -X 'GET' -H 'Accept: application/json' -H 'NS: test' -H 'DB: '$db http://localhost:8000/export > dump.surql
  cd $pwd

done
