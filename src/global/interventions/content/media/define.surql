-- table
DEFINE TABLE media SCHEMAFULL PERMISSIONS
  FOR select WHERE $auth,
  FOR create, update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD alt  ON TABLE media TYPE option<string>;
DEFINE FIELD url  ON TABLE media TYPE string ASSERT string::is::url($value);
DEFINE FIELD type ON TABLE media TYPE string ASSERT $value INSIDE ['image', 'video'];

-- indexes

-- events
DEFINE EVENT media_log ON TABLE media WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
