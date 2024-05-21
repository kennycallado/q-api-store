-- table
DEFINE TABLE users SCHEMAFULL TYPE NORMAL PERMISSIONS
  FOR select, create, update WHERE $token.role IN ['admin', 'coord', 'thera']
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
-- DEFINE FIELD pass   ON TABLE users TYPE string VALUE $before OR crypto::argon2::generate($value) PERMISSIONS FOR select NONE;
-- DEFINE FIELD pass   ON TABLE users TYPE string ASSERT string::startsWith($value, '$argon2id') PERMISSIONS FOR select, update, delete NONE;
DEFINE FIELD role   ON TABLE users TYPE option<string> ASSERT $value IN ['parti', 'guest'] DEFAULT 'parti';
DEFINE FIELD state  ON TABLE users TYPE option<string> ASSERT $value IN ['active', 'standby', 'exited', 'completed']  DEFAULT 'standby';

-- indexes

-- events
DEFINE EVENT users_init ON TABLE users WHEN $event IS 'CREATE' THEN {
  IF $value.role IN ['parti', 'guest'] {
    LET $id = $value.id;

    fn::on_init($id);
  };
};

DEFINE EVENT users_done ON TABLE users WHEN $event IS 'UPDATE' THEN {
  IF $value.state = 'completed' {
    LET $id = $value.id;

    fn::on_done($id);
  };
};

DEFINE EVENT users_log ON TABLE users WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  }
};
