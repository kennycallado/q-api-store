-- table
DEFINE TABLE centers SCHEMAFULL TYPE NORMAL PERMISSIONS
  FOR select, create, update, delete WHERE $auth
  ;

-- fields
DEFINE FIELD name ON TABLE centers TYPE string PERMISSIONS FOR update NONE;

-- indexes
DEFINE INDEX name_index ON TABLE centers FIELDS name UNIQUE;

-- events
DEFINE EVENT centers_log ON TABLE centers WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  }
};
