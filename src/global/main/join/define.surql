-- table
DEFINE TABLE join SCHEMALESS PERMISSIONS
  FOR select, create, update, delete WHERE $auth
  ;

-- fields
DEFINE FIELD completed ON TABLE join TYPE bool DEFAULT false ASSERT $value IS false OR score IS NOT NONE;
DEFINE FIELD score     ON TABLE join FLEXIBLE TYPE option<object> ASSERT $value IS NONE OR completed IS true;

-- index to enforce unique join
DEFINE INDEX unique_join ON TABLE join COLUMNS in, out UNIQUE;

-- events
DEFINE EVENT join_completed ON TABLE join WHEN $event IS 'UPDATE' AND $value.completed IS true THEN {
  -- ?? maybe update users table
  -- for now is done by the super
};

DEFINE EVENT join_logs ON TABLE join WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event IS 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  };
};
