#! /usr/bin/env bash

set -e
pwd=$(pwd)

db_url="http://localhost:8000"
db_user="-u root:root"

main() {
  local namespaces=("global" "interventions" "shared") # shared should be after interventions

  for ns in "${namespaces[@]}"; do
    cd "src/$ns"

    for folder in */; do
      if [ "$ns" == "interventions" ]; then

        for folder_in in "$folder"*/; do
          for file in "$folder_in"*.surql; do

            if [ "$folder" == "aux/" ] || [ "$folder" == "content/" ]; then
              echo "sharring $file"
              inject "shared" "main" "$file"
            fi

            echo "$file"
            inject "$ns" "main" "$file"
          done
        done
      else

        for file in "$folder"*.surql; do
          echo "$file"
          inject "$ns" "main" "$file"
        done
      fi
    done

    dump "$ns" "main"
    cd "$pwd"
  done
}

inject() {
  local ns=$1
  local db=$2
  local file=$3

  # should be temporary solution
  if [[ "$file" == *"create"* ]]; then
    return
  fi

  if [ -f "$file" ]; then
    curl $db_user -sS -X 'POST' -H 'Accept: application/json' -H "NS: $ns" -H "DB: $db" --data-binary @"$file" "$db_url/import" | jq '.[] | .status + " " + .time'
  else
    echo -e "\033[0;31mFile not found:\033[0m $file"
  fi
}

dump() {
  local ns=$1
  local db=$2

  curl $db_user -sS -X 'GET' -H 'Accept: application/json' -H "NS: $ns" -H "DB: $db" "$db_url/export" > dump.surql
}

main "$@"

cd "$pwd"
exit 0
