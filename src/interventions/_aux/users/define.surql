-- table
DEFINE TABLE users SCHEMAFULL PERMISSIONS
  FOR select WHERE $auth.admin;

-- fields
-- WARNING: pass is always crypted
-- DEFINE FIELD pass   ON TABLE users TYPE string;
DEFINE FIELD pass   ON TABLE users TYPE string VALUE crypto::argon2::generate($value);
DEFINE FIELD admin  ON TABLE users TYPE option<bool> DEFAULT false;
DEFINE FIELD active ON TABLE users TYPE option<bool> DEFAULT false;

-- indexes

-- events
DEFINE EVENT users_log ON TABLE users WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  }
};
