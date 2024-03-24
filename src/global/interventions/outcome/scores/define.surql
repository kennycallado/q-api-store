-- table
DEFINE TABLE scores SCHEMAFULL PERMISSIONS
  -- old -> FOR select, create WHERE user = $auth

  FOR create WHERE user = $auth,
  FOR select WHERE user = $auth OR $token.role IN ['admin', 'coord', 'thera'],
  FOR update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD user    ON TABLE scores TYPE record<users> PERMISSIONS FOR update NONE;
DEFINE FIELD score   ON TABLE scores FLEXIBLE TYPE object DEFAULT {};
DEFINE FIELD created ON TABLE scores TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

-- indexes

-- events
DEFINE EVENT scores_log ON TABLE scores WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
