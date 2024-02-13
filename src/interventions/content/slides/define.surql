-- table
DEFINE TABLE slides SCHEMAFULL PERMISSIONS
  FOR select WHERE $auth.id;

-- fields
DEFINE FIELD title    ON TABLE slides TYPE string;
DEFINE FIELD content  ON TABLE slides TYPE option<string>;
DEFINE FIELD media    ON TABLE slides TYPE option<record<media>>;
DEFINE FIELD type     ON TABLE slides TYPE string ASSERT $value INSIDE ['content', 'input'];
DEFINE FIELD question ON TABLE slides TYPE option<record<questions>> ASSERT $value IS NONE OR (type = 'input' AND questions = NONE);

-- indexes

-- events
DEFINE EVENT slides_log ON TABLE slides WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
