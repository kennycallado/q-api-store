-- table
DEFINE TABLE locales SCHEMAFULL TYPE NORMAL PERMISSIONS
  FOR select WHERE $auth,
  FOR create, update, delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
-- -- ISO 639-1
DEFINE FIELD locale ON TABLE locales TYPE string ASSERT string::len($value) = 2 AND $value IN ['en', 'es', 'ca'];

-- indexes

-- events
DEFINE EVENT locales_log ON TABLE locales WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  CREATE logs SET index = $value.id, event = $event, time = time::now();
};
