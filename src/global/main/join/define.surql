-- table
DEFINE TABLE join SCHEMALESS PERMISSIONS
  FOR select, create, update, delete WHERE $auth
  ;

-- fields
DEFINE FIELD completed ON TABLE join TYPE bool DEFAULT false;

-- index to enforce unique join
DEFINE INDEX unique_join ON TABLE join COLUMNS in, out UNIQUE;

-- events
DEFINE EVENT join_logs ON TABLE join WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event IS 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  };
};
