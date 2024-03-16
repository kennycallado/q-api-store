#! /usr/bin/env bash

set -e
pwd=$(pwd)

db_url="http://localhost:8000"
db_user="-u root:root"

project_id="projects:1"
user_id="users:1"

main() {
  example="$1"
  ns="interventions"
  db="$example"

  # check example exist
  if [ ! -d "examples/$example" ]; then
    echo -e "\033[0;31mFolder not exist:\033[0m examples/$example"
    exit 1
  fi

  info_db=$(sql "$ns" "main" "INFO FOR DB;")

  inject_functions "$ns" "$db" "$info_db"
  inject_params "$ns" "$db" "$info_db"
  inject_scopes "$ns" "$db" "$info_db"
  inject_tables "$ns" "$db" "$info_db"

  create_roles
  create_user_project

  # inject data
  cd "examples/$example"

  for file in *.surql; do
    inject $ns $db "$file"
  done

  cd "$pwd"
}

create_roles() {
  roles=$(sql "global" "main" "INSERT INTO roles [{id: roles:1, name: 'admin'}, {id: roles:2 , name: 'coord'}, {id: roles:3, name: 'thera'}, {id: roles:4, name: 'parti'}, {id: roles:5, name: 'guest'}]")

  printf "\033[0;31m Creating roles: \033[0m \n"
  printf "\t$roles: \n"
}

create_user_project() {
  project=$(sql "global" "main" "LET \$q_project = (UPDATE $project_id SET name = '$example')[0]; RETURN \$q_project.token;")
  user=$(sql "global" "main" "UPDATE $user_id SET project = $project_id, username = 'kenny', role = roles:4;")

  project_token=$(echo $project | jq -r '.[1].result')

  printf "\033[0;31m Injecting project token: \033[0m \n"
  printf "\t$project_id: "
  sql "$ns" "$db" "DEFINE TOKEN user_scope ON SCOPE user TYPE HS256 VALUE '$project_token';" | jq '.[] | .status + " " + .time'
  printf " $project_token\n"
}

inject_params() {
  ns="$1"
  db="$2"
  info_db="$3"

  if [ "$(echo "$info_db" | jq '.[].result.params')" == "{}" ]; then
    return
  fi

  keys=$(echo "$info_db" | jq '.[].result.params' | jq 'keys')

  echo "$keys" | while read r_key; do
    if [ $r_key != "[" ] && [ $r_key != "]" ]; then
      key=$(echo $r_key | sed 's/\"//g' | sed 's/,//g' | sed 's/ //g')
      param=$(echo "$info_db" | jq -r '.[].result.params.'$key)

      printf "\033[0;32mInjecting param:\033[0m \n\t$key: "
      sql "$ns" "$db" "$param;" | jq '.[] | .status + " " + .time'
    fi
  done
}

inject_tables() {
  ns="$1"
  db="$2"
  info_db="$3"

  if [ "$(echo "$info_db" | jq '.[].result.tables')" == "{}" ]; then
    return
  fi

  keys=$(echo "$info_db" | jq '.[].result.tables' | jq 'keys')

  for r_key in $keys; do
    echo ""
    if [ $r_key != "[" ] && [ $r_key != "]" ]; then
      # clean key
      key=$(echo $r_key | sed 's/\"//g' | sed 's/,//g' | sed 's/ //g')

      if [ "$key" == "logs" ]; then
        continue
      fi

      # get info for table
      info_table=$(sql "$ns" "main" "INFO FOR TB $key;")

      # define table
      define_table=$(echo "$info_db" | jq -r '.[].result.tables.'$key)
      printf "\033[0;34mDefine table:\033[0m \n\t$key: "
      sql "$ns" "$db" "$define_table;" | jq '.[] | .status + " " + .time'

      # inject events
      table_events=$(echo "$info_table" | jq '.[].result.events | map(.)')
      n_events=$(echo "$table_events" | jq -r 'length')

      for (( i=0; i<$n_events; i++ )); do
        r_event=$(echo "$table_events" | jq -r ".[$i]")
        event=$(echo "$r_event" | sed 's/\"//g')
        printf "  \033[0;33mDefine event:\033[0m \n\t$(echo $event | awk '{print $3}'): "
        sql "$ns" "$db" "$event;" | jq '.[] | .status + " " + .time'
      done

      # inject fields
      table_fields=$(echo "$info_table" | jq -r '.[].result.fields | map(.)')
      n_fields=$(echo "$table_fields" | jq 'length')

      for (( i=0; i<$n_fields; i++ )); do
        r_field=$(echo "$table_fields" | jq -r ".[$i]")
        field=$(echo "$r_field" | sed 's/\"//g')
        printf "  \033[0;35mDefine field:\033[0m \n\t$(echo $field | awk '{print $3}'): "
        sql "$ns" "$db" "$field;" | jq '.[] | .status + " " + .time'
      done

    fi
  done
}

inject_scopes() {
  ns="$1"
  db="$2"
  info_db="$3"

  if [ "$(echo "$info_db" | jq '.[].result.scopes')" == "{}" ]; then
    return
  fi

  keys=$(echo "$info_db" | jq '.[].result.scopes' | jq 'keys')

  for r_key in $keys; do
    if [ $r_key != "[" ] && [ $r_key != "]" ]; then
      key=$(echo $r_key | sed 's/\"//g' | sed 's/,//g' | sed 's/ //g')
      scope=$(echo "$info_db" | jq -r '.[].result.scopes.'$key)

      printf "\033[0;36mInjecting scopes:\033[0m \n\t$key: "
      sql "$ns" "$db" "$scope;" | jq '.[] | .status + " " + .time'
    fi
  done
}

inject_functions() {
  ns="$1"
  db="$2"
  info_db="$3"

  if [ "$(echo "$info_db" | jq '.[].result.functions')" == "{}" ]; then
    return
  fi

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
