-- table
DEFINE TABLE messages SCHEMAFULL TYPE NORMAL PERMISSIONS
  FOR select WHERE $auth,
  FOR create, update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

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
