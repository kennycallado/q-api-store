#! /usr/bin/env bash

set -e
pwd=$(pwd)

db_url="http://localhost:8000"
db_user="-u root:root"

main() {
  local namespaces=("global")
  # local namespaces=("global" "shared")

  for ns in "${namespaces[@]}"; do
    cd "src/$ns"

    for folder in */; do
      local db=${folder%/}

        for folder_in in "$folder"*/; do
          if [[ "$folder_in" == *"interventions"* ]]; then

            for folder_in_in in "$folder_in"*/; do
              for file in "$folder_in_in"*.surql; do
                echo "$ns" "interventions" "$file"
                inject "$ns" "interventions" "$file"
              done
            done

          else

            for file in "$folder_in"*.surql; do

              if [ "$folder" == "aux/" ] || [ "$folder" == "content/" ]; then
                echo "sharing $file"
                inject "shared" "main" "$file"
              fi

              echo "$file"
              inject "$ns" "main" "$file"
            done

          fi

        done

        dump $ns $db $folder
    done

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
  local folder=$3

  curl $db_user -sS -X 'GET' -H 'Accept: application/json' -H "NS: $ns" -H "DB: $db" "$db_url/export" > "$folder/dump.surql"
}

main "$@"

cd "$pwd"
exit 0
