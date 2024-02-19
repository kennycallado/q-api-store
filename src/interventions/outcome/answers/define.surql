-- table
DEFINE TABLE answers SCHEMAFULL PERMISSIONS
  FOR select, create, update WHERE user = $auth
  ;

-- fields
DEFINE FIELD user     ON TABLE answers TYPE record<users> PERMISSIONS FOR update NONE;
DEFINE FIELD answer   ON TABLE answers TYPE string;
DEFINE FIELD question ON TABLE answers TYPE record<questions> PERMISSIONS FOR update NONE;

-- indexes

-- events
DEFINE EVENT answers_log ON TABLE answers WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  }
};
