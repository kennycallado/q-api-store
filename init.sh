#! /usr/bin/env bash

set -e
pwd=$(pwd)

db_url="http://localhost:8000"
db_user="-u root:root"

main() {
  # profiles is temporary in db
  local namespaces=("profiles" "interventions" "user_project")

  for ns in "${namespaces[@]}"; do
    cd "src/$ns"

    for folder in */; do
      if [ "$ns" == "interventions" ]; then
        if [ "$folder" == "_scopes/" ]; then

          for file in "$folder"*.surql; do
            inject "$ns" "main" "$file"
          done
        else

          for folder_in in "$folder"*/; do
            for file in "$folder_in"*.surql; do
              inject "$ns" "main" "$file"
            done
          done
        fi
      else # profiles and user_project

        if [ "$file" == "${folder}define.surql" ]; then
          inject "$ns" "main" "$file"
        fi
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

  echo "$file"
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
