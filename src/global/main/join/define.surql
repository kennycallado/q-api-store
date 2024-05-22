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
DEFINE EVENT check_can_join ON TABLE join WHEN $event IS 'CREATE' THEN {
  LET $id = $value.id;
  
  $foo = (
    SELECT
      (<-users->roled[WHERE out IS $value.out.center].role)[0] AS role,
      (SELECT VALUE count(->join[WHERE state IS NOT 'completed']) -1 FROM $value.in)[0] AS uncompleted
    FROM ONLY $id
  );

  IF $foo.role IS NONE { 
    THROW 'User is not in roled';
  } ELSE IF $foo.role IN ['parti', 'guest'] {
    IF $foo.uncompleted > 0 {
      THROW 'User is already in a project';
    };
  };

};

DEFINE EVENT completed ON TABLE join WHEN $event IS 'UPDATE' AND $value.state IS 'completed' THEN {
  UPDATE $value.in SET project = NONE;
};

DEFINE EVENT logs ON TABLE join WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  CREATE logs SET index = $value.id,  event = $event, time = time::now();
};
