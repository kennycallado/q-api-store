-- table
DEFINE TABLE slides SCHEMAFULL TYPE ANY PERMISSIONS
  FOR select WHERE $auth,
  FOR create, update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD title    ON TABLE slides TYPE string;
DEFINE FIELD elements ON TABLE slides TYPE array<record<media|paragraphs|questions>>;
DEFINE FIELD ref      ON TABLE slides TYPE string ASSERT $value IS NOT EMPTY VALUE string::slug(string::lowercase($value));

-- indexes

-- events
DEFINE EVENT slides_log ON TABLE slides WHEN $event = ['CREATE', 'UPDATE', 'DELETE'] THEN {
  CREATE logs SET index = $value.id, event = $event, time = time::now();
};
