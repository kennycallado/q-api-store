-- table
DEFINE TABLE join SCHEMAFULL TYPE RELATION IN users OUT projects PERMISSIONS
  FOR select, create, update, delete WHERE $auth;

-- fields
DEFINE FIELD created ON TABLE join TYPE option<datetime> VALUE $before OR time::now();
DEFINE FIELD updated ON TABLE join TYPE option<datetime> VALUE time::now();
DEFINE FIELD state   ON TABLE join TYPE option<string>   ASSERT $value IN ['active', 'standby', 'exited', 'completed', NONE];

-- DEFINE FIELD completed ON TABLE join TYPE bool DEFAULT false ASSERT $value IS false OR score IS NOT NONE;
-- DEFINE FIELD score ON TABLE join FLEXIBLE TYPE option<object>
-- ;
  -- WARNING: needs to debug
  -- ASSERT $value IS NONE
  --   OR $before IS NONE
  --   AND state IS 'completed'
  --   AND object::keys($value) CONTAINSALL (SELECT VALUE keys FROM ONLY $this.out LIMIT 1)
  --   OR [];

-- index to enforce unique join
DEFINE INDEX unique ON TABLE join COLUMNS in, out UNIQUE;

-- events
DEFINE EVENT join_completed ON TABLE join WHEN $event IS 'UPDATE' AND $value.state IS 'completed' THEN {
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
