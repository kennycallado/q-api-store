-- table
DEFINE TABLE messages PERMISSIONS NONE;

-- fields
DEFINE FIELD title ON TABLE messages TYPE string;
DEFINE FIELD body  ON TABLE messages TYPE string;
DEFINE FIELD type  ON TABLE messages TYPE string;
DEFINE FIELD data  ON TABLE messages FLEXIBLE TYPE object;

-- indexes

-- events
DEFINE EVENT messages_log ON TABLE messages WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
