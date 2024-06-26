-- table
DEFINE TABLE resources SCHEMAFULL TYPE ANY PERMISSIONS
  FOR select WHERE $auth,
  FOR create, update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD description  ON TABLE resources TYPE string;
DEFINE FIELD title        ON TABLE resources TYPE string ASSERT $value IS NOT EMPTY;
DEFINE FIELD ref          ON TABLE resources TYPE string ASSERT $value IS NOT EMPTY VALUE string::slug(string::lowercase($value));
DEFINE FIELD type         ON TABLE resources TYPE string ASSERT $value INSIDE ['slides','module','form','external'];

-- -- form
DEFINE FIELD form ON TABLE resources TYPE option<array<record<questions>>> ASSERT $value IS NONE OR type = 'form' AND array::len($value) > 0;

-- -- module
DEFINE FIELD module ON TABLE resources TYPE option<array<record<slides>>> ASSERT $value IS NONE OR type = 'module' AND array::len($value) > 0;

-- -- slides
DEFINE FIELD slides ON TABLE resources TYPE option<array<record<slides>>> ASSERT $value IS NONE OR type = 'slides' AND array::len($value) > 0;

-- indexes
DEFINE INDEX resources_ref_unique ON TABLE resources FIELDS ref UNIQUE;

-- events
DEFINE EVENT resources_log ON TABLE resources WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
