#!/bin/bash

set -e

# cat ./base/create.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: main' --data-binary @- http://localhost:8000/import &> /dev/null
#
# inject_base=true

layers=("project" "content" "outcome")
entities=( \
  "project/projects" \
  "project/users" \
  "content/locales" \
  "content/media" \
  "content/questions" \
  "content/slides" \
  "content/resources" \
  "outcome/answers" \
  "outcome/papers" \
  "outcome/scores" \
  "outcome/scripts" \
)

# inject base
if [ "$inject_base" = true ]; then
  for layer in ${layers[@]} ;do
    if [[ "$layer" == *"content"* ]]; then
      db="content"
    else if [[ "$layer" == *"outcome"* ]]; then
      db="outcome"
    else if [[ "$layer" == *"project"* ]]; then
      db="project"
    fi
    fi
    fi

    printf "\nDefinning base for $layer...\n"
    cat ./base/create.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: main' -H 'DB: '$db --data-binary @- http://localhost:8000/import
  done
fi

# inject data
for entity in ${entities[@]}; do
  if [[ "$entity" == *"content"* ]]; then
    db="content"
  else if [[ "$entity" == *"outcome"* ]]; then
    db="outcome"
  else if [[ "$entity" == *"project"* ]]; then
    db="project"
  fi
  fi
  fi

  pwd=$(pwd)
  cd src/$entity

  if [ -f "./define.surql" ]; then
    printf "\nDefinning $entity...\n"
    cat ./define.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: main' -H 'DB: '$db --data-binary @- http://localhost:8000/import
  fi

  if [ -f "./create.surql" ]; then
    printf "\nCreating $entity...\n"
    cat ./create.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: main' -H 'DB: '$db --data-binary @- http://localhost:8000/import
  fi

  cd $pwd
done

# export dump
for layer in ${layers[@]} ;do
  if [[ "$layer" == *"content"* ]]; then
    db="content"
  else if [[ "$layer" == *"outcome"* ]]; then
    db="outcome"
  else if [[ "$layer" == *"project"* ]]; then
    db="project"
  fi
  fi
  fi

  pwd=$(pwd)
  cd src/$layer
  printf "\nExporting $layer...\n"
  curl -sS -X 'GET' -H 'Accept: application/json' -H 'NS: main' -H 'DB: '$db http://localhost:8000/export > dump.surql
  cd $pwd
done
