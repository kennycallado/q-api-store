-- table
DEFINE TABLE scripts SCHEMAFULL PERMISSIONS
  FOR select WHERE $auth,
  FOR create, update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD name ON TABLE scripts TYPE string;
DEFINE FIELD code ON TABLE scripts TYPE string;

-- indexes
DEFINE INDEX scripts_name ON TABLE scripts FIELDS name;

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
UPDATE scripts:init SET name = 'init', code = 'console.log("on_init")';
UPDATE scripts:push SET name = 'push', code = 'console.log("on_push")';
UPDATE scripts:done SET name = 'done', code = 'console.log("on_done")';
