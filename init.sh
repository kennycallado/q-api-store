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
  "content/scripts" \
  "outcome/answers" \
  "outcome/functions" \
  "outcome/papers" \
  "outcome/scores" \
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

# clean seeds and prepare
for layer in ${layers[@]}; do
  echo "" > src/$layer/seed.surql

  cat <<EOF >> src/$layer/seed.surql
-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

EOF
done
# end clean seeds


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

cat <<EOF >> ../seed.surql
-- ------------------------------
-- TABLE DATA: $entity
-- ------------------------------

EOF

if [ -f "./create.surql" ]; then
  cat ./create.surql >> ../seed.surql
fi

cat <<EOF >> ../seed.surql

EOF

  # if [ -f "./create.surql" ]; then
  #   printf "\nCreating $entity...\n"
  #   cat ./create.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: main' -H 'DB: '$db --data-binary @- http://localhost:8000/import
  # fi

  cd $pwd
done
# end inject data

# end prepare seeds
for layer in ${layers[@]}; do
  cat <<EOF >> src/$layer/seed.surql
-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

EOF
done
# end prepare seeds

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
