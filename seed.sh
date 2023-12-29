#! /usr/bin/env bash

set -e
pwd=$(pwd)

db_url="http://localhost:8000"
db_user="-u root:root"

main() {
  example="$1"
  ns="interventions"
  db="$example"

  if [ -z "$example" ]; then
    echo "Example not found"
    exit 1
  fi

  info_db=$(sql "$ns" "main" "INFO FOR DB;")

  inject_functions "$ns" "$db" "$info_db"
  inject_tables "$ns" "$db" "$info_db"

  # inject data
  cd "examples/$example"

  for folder in `ls -d1 */`; do
    ns=${folder%/}
    db="$example"

    for file in `ls $folder`; do
      if [ $ns == "user_project" ]; then
        db="main"
      else
        db="$example"
      fi

      inject $ns $db "$ns/$file"
    done

    ns=""
    db=""
  done

  cd "$pwd"
}

inject_tables() {
  ns="$1"
  db="$2"
  info_db="$3"

  keys=$(echo "$info_db" | jq '.[].result.tables' | jq 'keys')

  for r_key in $keys; do
    echo ""
    if [ $r_key != "[" ] && [ $r_key != "]" ]; then
      # clean key
      key=$(echo $r_key | sed 's/\"//g' | sed 's/,//g' | sed 's/ //g')

      # get info for table
      info_table=$(sql "$ns" "main" "INFO FOR TB $key;")

      # define table
      define_table=$(echo "$info_db" | jq -r '.[].result.tables.'$key)
      printf "\033[0;34mDefine table:\033[0m \n\t$key: "
      sql "$ns" "$db" "$define_table;" | jq '.[] | .status + " " + .time'

      # inject events
      table_events=$(echo "$info_table" | jq '.[].result.events | map(.)' | jq -r '.[]')
      echo "$table_events" | while read r_event; do
        event=$(echo "$r_event" | sed 's/\"//g')
        printf "  \033[0;33mDefine event:\033[0m \n\t$(echo $event | awk '{print $3}'): "
        sql "$ns" "$db" "$event;" | jq '.[] | .status + " " + .time'
      done

      # inject fields
      table_fields=$(echo "$info_table" | jq '.[].result.fields | map(.)')
      echo "$table_fields" | jq '.[]' | while read r_field; do
        field=$(echo "$r_field" | sed 's/\"//g')
        printf "  \033[0;35mDefine field:\033[0m \n\t$(echo $field | awk '{print $3}'): "
        sql "$ns" "$db" "$field;" | jq '.[] | .status + " " + .time'
      done

    fi
  done
}

inject_functions() {
  ns="$1"
  db="$2"
  info_db="$3"

  keys=$(echo "$info_db" | jq '.[].result.functions' | jq 'keys')

  for r_key in $keys; do
    if [ $r_key != "[" ] && [ $r_key != "]" ]; then
      key=$(echo $r_key | sed 's/\"//g' | sed 's/,//g' | sed 's/ //g')
      function=$(echo "$info_db" | jq -r '.[].result.functions.'$key)

      printf "\033[0;31mInjecting function:\033[0m \n\t$key: "
      sql "$ns" "$db" "$function;" | jq '.[] | .status + " " + .time'
    fi
  done
}

sql() {
  curl $db_user -sS -X POST \
    -H "NS: $1" \
    -H "DB: $2" \
    -H "Accept: application/json" \
    -d "$3" \
    $db_url/sql
}

inject() {
  local ns=$1
  local db=$2
  local file=$3

  echo "$file"
  if [ -f "$file" ] && [[ $file == *.surql ]]; then
    curl $db_user -sS -X 'POST' -H 'Accept: application/json' -H "NS: $ns" -H "DB: $db" --data-binary @"$file" "$db_url/import" | jq '.[] | .status + " " + .time'
  else
    echo -e "\033[0;31mNot surql file:\033[0m $file"
  fi
}

main "$@"

cd "$pwd"
exit 0
