-- table
DEFINE TABLE belongs SCHEMAFULL TYPE RELATION IN projects OUT centers PERMISSIONS
  FOR select, create, update, delete WHERE $auth;

-- fields
-- DEFINE FIELD role ON TABLE belongs TYPE string ASSERT $value IN ['admin', 'coord', 'thera', 'parti', 'guest'];

-- indexes
DEFINE INDEX unique_relation ON TABLE belongs COLUMNS in, out UNIQUE;
DEFINE INDEX unique_project  ON TABLE belongs COLUMNS in UNIQUE;

-- events
DEFINE EVENT logs ON TABLE belongs WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  CREATE logs SET index = $value.id,  event = $event, time = time::now();
};
