-- table
DEFINE TABLE jobs SCHEMAFULL PERMISSIONS
  FOR select, create, update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD event    ON TABLE jobs TYPE record<event>;
DEFINE FIELD job_id   ON TABLE jobs TYPE option<uuid> DEFAULT NONE;
DEFINE FIELD status   ON TABLE jobs TYPE option<string> ASSERT $value IS NONE OR $value IN ['scheduled', 'running', 'failed', 'done'];

-- indexes
DEFINE INDEX event_index ON TABLE jobs FIELDS event UNIQUE;

-- events
DEFINE EVENT events_log ON TABLE events WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
