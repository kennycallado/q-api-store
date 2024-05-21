-- table
DEFINE TABLE roled SCHEMAFULL TYPE RELATION IN users OUT centers PERMISSIONS
  FOR select, create, update, delete WHERE $auth;

-- fields
DEFINE FIELD role ON TABLE roled TYPE string ASSERT $value IN ['admin', 'coord', 'thera', 'parti', 'guest'];

-- indexes
DEFINE INDEX unique ON TABLE roled COLUMNS in, out UNIQUE;

-- events
DEFINE EVENT roled_log ON TABLE roled WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  CREATE logs SET index = $value.id,  event = $event, time = time::now();
};
