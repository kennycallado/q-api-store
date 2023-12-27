#! /usr/bin/env bash

set -e
pwd=$(pwd)

main() {
  # profiles is temporary in db
  local namespaces=("profiles" "interventions" "user_project")

  for ns in "${namespaces[@]}"; do
    cd "src/$ns"

    for folder in */; do
      if [ "$folder" == "_functions/" ]; then

        for folder_in in "$folder"*/; do
          for file in "$folder_in"*.surql; do
            inject "$ns" "main" "$file"
          done
        done

      else

        for file in "$folder"*.surql; do
          if [ "$file" == "${folder}define.surql" ]; then
            inject "$ns" "main" "$file"
          fi
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

  if [ -f "$file" ]; then
    curl -sS -X 'POST' -H 'Accept: application/json' -H "NS: $ns" -H "DB: $db" --data-binary @"$file" http://localhost:8000/import | jq '.[] | .status + " " + .time'
  else
    echo -e "\033[0;31mFile not found:\033[0m $file"
  fi
}

dump() {
  local ns=$1
  local db=$2

  curl -sS -X 'GET' -H 'Accept: application/json' -H "NS: $ns" -H "DB: $db" http://localhost:8000/export > dump.surql
}

main "$@"

cd "$pwd"
exit 0
