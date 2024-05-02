-- table
DEFINE TABLE scripts SCHEMAFULL TYPE NORMAL PERMISSIONS
  FOR select WHERE $auth,
  FOR create, update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD name ON TABLE scripts TYPE string;
DEFINE FIELD code ON TABLE scripts TYPE string;

-- indexes
-- WARNING: something is wrong with the UNIQUE constraint
-- DEFINE INDEX scripts_name ON TABLE scripts COLUMNS name UNIQUE;

-- events
-- -- on create update sanitize
DEFINE EVENT scripts_log ON TABLE scripts WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};

-- DEFAULT scripts
CREATE scripts:on_init SET name = 'init', code = 'console.log("on_init")';
CREATE scripts:on_push SET name = 'push', code = 'console.log("on_push")';
CREATE scripts:on_done SET name = 'done', code = 'console.log("on_done")';
