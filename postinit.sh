#!/bin/bash

set -e

db_url="http://localhost:8000"
user=""
layers=("content" "outcome")

_jq() {
  echo ${row} | base64 --decode | jq -r ${1}
}

get_projects() {
  curl ${user} -sS -H 'Accept: application/json' -H 'NS: main' -H 'DB: project' -d 'SELECT * FROM projects' "$db_url/sql"
}

inject_dump() {
  local layer=$1
  local db=$2

  printf "\nDefinning base for $layer...\n"

  local pwd=$(pwd)
  cd src/$layer
  cat ./dump.surql | curl ${user} -sS -X 'POST' -H 'Accept: application/json' -H 'NS: projects' -H 'DB: '$db --data-binary @- "$db_url/import" |  jq '.[] | .status + " " + .time'
  cd $pwd

  echo -e "\n------------"
  echo "Project $db has been initialized."
  echo "------------"
}

seed_project() {
  local db=$1

  echo "Would you like to seed $db? (y/n)"
  read seed

  if [ $seed == "y" ]; then
    copy_functions $db
    seed_layers $db
  fi
}

copy_functions() {
  local db=$1

  printf "\nCopy the functions $layer...\n"
  cat ./src/outcome/functions/define.surql | curl ${user} -sS -X 'POST' -H 'Accept: application/json' -H 'NS: projects' -H 'DB: '$db --data-binary @- "$db_url/import" | jq '.[] | .status + " " + .time'
}

seed_layers() {
  local db=$1

  for layer in ${layers[@]}; do
    printf "\nSeeding $layer...\n"

    local pwd=$(pwd)
    cd src/$layer
    cat ./seed.surql | curl ${user} -sS -X 'POST' -H 'Accept: application/json' -H 'NS: projects' -H 'DB: '$db --data-binary @- "$db_url/import" | jq '.[] | .status + " " + .time'
    cd $pwd
  done
}

main() {
  projects=$(get_projects)
  for row in $(echo "${projects}" | jq -r '.[].result[] | @base64'); do
    project_id=$(echo $(_jq '.id'))
    project_name=$(echo $(_jq '.name'))

    for layer in ${layers[@]}; do
      inject_dump $layer $project_name
    done

    seed_project $project_name
  done
}

main @
