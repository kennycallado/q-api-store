-- table
DEFINE TABLE users SCHEMAFULL PERMISSIONS
  FOR select, create, update WHERE $token.role IN ['admin', 'coord', 'thera']
  FOR delete WHERE $token.role IN ['admin', 'coord']
;

-- fields
-- WARNING: pass is always crypted
DEFINE FIELD pass   ON TABLE users TYPE string VALUE crypto::argon2::generate($value) PERMISSIONS FOR select NONE;
DEFINE FIELD active ON TABLE users TYPE option<bool> DEFAULT false;
-- DEFINE FIELD role   ON TABLE users TYPE option<string>
--   ASSERT $value IN ['admin', 'user', 'guest'] DEFAULT 'user';

-- indexes

-- events
DEFINE EVENT users_log ON TABLE users WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  }
};
