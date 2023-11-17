-- table
DEFINE TABLE records SCHEMAFULL PERMISSIONS NONE;

-- fields
DEFINE FIELD user     ON TABLE records TYPE record<users>;
DEFINE FIELD record   ON TABLE records FLEXIBLE TYPE object DEFAULT {};
DEFINE FIELD created  ON TABLE records TYPE datetime DEFAULT time::now();

-- indexes

-- events
DEFINE EVENT p_generate_record ON TABLE records WHEN $event IS "CREATE" THEN {
  RELATE $project->generate_record->$value;
};

DEFINE EVENT records_log ON TABLE records WHEN $event IS "CREATE" OR $event IS "UPDATE" OR $event IS "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
