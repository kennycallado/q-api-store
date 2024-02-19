-- table
DEFINE TABLE users SCHEMAFULL PERMISSIONS
  FOR select, update WHERE id = $auth;

-- fields
DEFINE FIELD username ON TABLE users TYPE string PERMISSIONS FOR update NONE;
DEFINE FIELD project  ON TABLE users TYPE option<record<projects>> PERMISSIONS FOR update NONE;

-- DEFINE FIELD devices ON users TYPE array<record<devices>>;
DEFINE FIELD web_token    ON TABLE users FLEXIBLE TYPE option<object> DEFAULT {} PERMISSIONS FOR select NONE;
DEFINE FIELD web_token.endpoint    ON TABLE users TYPE option<string>;
DEFINE FIELD web_token.keys        ON TABLE users TYPE option<object>;
DEFINE FIELD web_token.keys.auth   ON TABLE users TYPE option<string>;
DEFINE FIELD web_token.keys.p256dh ON TABLE users TYPE option<string>;

-- indexes
DEFINE INDEX users_username ON TABLE users FIELDS username UNIQUE;

-- events
DEFINE EVENT users_log ON TABLE users WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event IS 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  };
};
