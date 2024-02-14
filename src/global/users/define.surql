-- table
DEFINE TABLE users SCHEMAFULL PERMISSIONS NONE;

-- fields
DEFINE FIELD username ON users TYPE string;
DEFINE FIELD password ON users TYPE string;
DEFINE FIELD project  ON users TYPE option<record<projects>>;

-- indexes
DEFINE INDEX users_username ON TABLE users FIELDS username UNIQUE;

-- events
DEFINE EVENT users_log ON TABLE users WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event IS 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  }
};
