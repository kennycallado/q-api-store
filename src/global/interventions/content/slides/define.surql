-- table
DEFINE TABLE slides SCHEMAFULL TYPE ANY PERMISSIONS
  FOR select WHERE $auth,
  FOR create, update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD title    ON TABLE slides TYPE string;
DEFINE FIELD content  ON TABLE slides TYPE option<string>;
DEFINE FIELD media    ON TABLE slides TYPE option<record<media>>;
DEFINE FIELD type     ON TABLE slides TYPE string ASSERT $value INSIDE ['content', 'input'];
DEFINE FIELD ref      ON TABLE slides TYPE string ASSERT $value IS NOT EMPTY VALUE string::slug(string::lowercase($value));
DEFINE FIELD question ON TABLE slides TYPE option<record<questions>> ASSERT $value IS NONE OR (type = 'input' AND questions = NONE);

-- indexes

-- events
DEFINE EVENT slides_log ON TABLE slides WHEN $event = ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
