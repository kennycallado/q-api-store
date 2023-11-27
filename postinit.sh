#/bin/bash

#

set -e

db_url="http://localhost:8000"
user=""

layers=("content" "outcome")

_jq() {
  echo ${row} | base64 --decode | jq -r ${1}
}

projects=$(curl ${user} -sS -H 'Accept: application/json' -H 'NS: main' -H 'DB: project' -d 'SELECT * FROM projects' "$db_url/sql")
for row in $(echo "${projects}" | jq -r '.[].result[] | @base64'); do

  project_id=$(echo $(_jq '.id'))
  project_name=$(echo $(_jq '.name'))
  # ??? if state == 'development' ns = 'dev' else ns = 'main'

  # inject dump
  for layer in ${layers[@]}; do
    db=$project_name
    printf "\nDefinning base for $layer...\n"

    pwd=$(pwd)
    cd src/$layer
    cat ./dump.surql | curl ${user} -X 'POST' -H 'Accept: application/json' -H 'NS: project' -H 'DB: '$db --data-binary @- "$db_url/import"
    cd $pwd
  done

  # seed
  echo -e "\n------------"
  echo "Project $project_name has been initialized."
  echo "------------"
  echo "Would you like to seed $project_name? (y/n)"
  read seed

  if [ $seed == "y" ]; then
    for layer in ${layers[@]}; do
      db=$project_name
      printf "\nSeeding $layer...\n"

      pwd=$(pwd)
      cd src/$layer
      cat ./seed.surql | curl -X 'POST' -H 'Accept: application/json' -H 'NS: projects' -H 'DB: '$db --data-binary @- http://localhost:8000/import
      cd $pwd
    done
  fi
  # end seed

done
