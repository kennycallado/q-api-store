-- table
DEFINE TABLE answers SCHEMAFULL PERMISSIONS
  FOR select WHERE $auth.admin,
  FOR create, update WHERE $auth.id
  ;

-- fields
DEFINE FIELD answer   ON TABLE answers TYPE string;
DEFINE FIELD question ON TABLE answers TYPE record<questions>;

-- indexes

-- events
-- DEFINE EVENT u_create_answer ON TABLE answers WHEN $event = "CREATE" THEN {
--   LET $user = $auth.id;
--   IF $user != NONE {
--     RELATE $user->create_answer->$value;
--   };
-- };

DEFINE EVENT answers_log ON TABLE answers WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  }
};
