-- table
DEFINE TABLE users SCHEMAFULL PERMISSIONS NONE;

-- fields
DEFINE FIELD project ON users TYPE option<record<projects>>;

-- indexes

-- events
DEFINE EVENT users_log ON TABLE users WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  }
};
