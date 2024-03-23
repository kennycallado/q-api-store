-- table
DEFINE TABLE users SCHEMAFULL PERMISSIONS
  -- FOR select, update WHERE id = $auth
  FOR select, create, update, delete WHERE $auth
  ;

-- fields
DEFINE FIELD username ON TABLE users TYPE string PERMISSIONS FOR update NONE;
DEFINE FIELD password ON TABLE users TYPE string VALUE $before OR crypto::argon2::generate($value) PERMISSIONS FOR select, update NONE;
DEFINE FIELD project  ON TABLE users TYPE option<record<projects>> PERMISSIONS FOR update WHERE $token.role IN ['robot', 'admin', 'coord'];
DEFINE FIELD role     ON TABLE users TYPE option<string>
  ASSERT $value IN ['robot', 'admin', 'coord', 'thera', 'parti', 'guest'] DEFAULT 'parti' PERMISSIONS FOR update NONE;
  -- DEFINE FIELD role ON TABLE users TYPE record<roles> PERMISSIONS FOR update NONE;

-- DEFINE FIELD devices ON users TYPE array<record<devices>>;
DEFINE FIELD web_token ON TABLE users FLEXIBLE TYPE option<object> DEFAULT {} PERMISSIONS FOR select NONE;
DEFINE FIELD web_token.endpoint    ON TABLE users TYPE option<string>;
DEFINE FIELD web_token.keys        ON TABLE users TYPE option<object>;
DEFINE FIELD web_token.keys.auth   ON TABLE users TYPE option<string>;
DEFINE FIELD web_token.keys.p256dh ON TABLE users TYPE option<string>;

-- indexes
DEFINE INDEX username_index ON TABLE users FIELDS username UNIQUE;

-- events
DEFINE EVENT users_log ON TABLE users WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event IS 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  };
};

DEFINE EVENT users_join ON TABLE users WHEN $event IN ['CREATE', 'UPDATE'] THEN {
  IF $value.project IS NOT NONE {
    LET $id = $value.id;
    LET $project = $value.project;

    IF (SELECT id FROM join WHERE in = $id AND out = $project) {
      UPDATE join SET last_time = time::now() WHERE in = $id AND out = $project;
    } ELSE {
      RELATE $id->join->$project CONTENT {  frist_time: time::now(), last_time: time::now() };
    };

  };
};
