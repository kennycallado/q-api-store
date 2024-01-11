-- table
DEFINE TABLE scores SCHEMAFULL PERMISSIONS
  FOR select WHERE $auth.admin OR user = $auth.id,
  FOR create WHERE user = $auth.id;

-- fields
DEFINE FIELD user     ON TABLE scores TYPE record<users>;
DEFINE FIELD score    ON TABLE scores FLEXIBLE TYPE object DEFAULT {};
DEFINE FIELD created  ON TABLE scores TYPE datetime DEFAULT time::now();

-- indexes

-- events
DEFINE EVENT scores_log ON TABLE scores WHEN $event IS "CREATE" OR $event IS "UPDATE" OR $event IS "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
