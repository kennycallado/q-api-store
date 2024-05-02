-- table
DEFINE TABLE answers SCHEMAFULL TYPE ANY PERMISSIONS
  -- old -> FOR select, create, update WHERE user = $auth

  -- if production only allow admin, coord
  FOR select  WHERE user = $auth,
  FOR create,
      update  WHERE user = $auth OR $token.role IN ['admin', 'coord', 'thera'],
  FOR delete  WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD user     ON TABLE answers TYPE record<users> PERMISSIONS FOR update NONE;
DEFINE FIELD answer   ON TABLE answers TYPE string;
DEFINE FIELD question ON TABLE answers TYPE record<questions> PERMISSIONS FOR update NONE;

-- indexes

-- events
DEFINE EVENT answers_log ON TABLE answers WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  }
};
