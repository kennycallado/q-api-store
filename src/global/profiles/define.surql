-- table
DEFINE TABLE profiles SCHEMAFULL PERMISSIONS NONE;

-- fields
DEFINE FIELD name  ON TABLE profiles TYPE string;
DEFINE FIELD token ON TABLE profiles TYPE string;

-- indexes

-- events
-- -- on create update sanitize
DEFINE EVENT profiles_log ON TABLE profiles WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
