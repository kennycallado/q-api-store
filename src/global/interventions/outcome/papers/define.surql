-- table
DEFINE TABLE papers SCHEMAFULL TYPE ANY PERMISSIONS
  -- old -> FOR select, create, update WHERE user = $auth

  -- if production only allow admin, coord
  FOR select  WHERE user = $auth OR $token.role IN ['admin', 'coord', 'thera'],
  FOR create,
      update  WHERE user = $auth OR $token.role IN ['admin', 'coord', 'thera'],
  FOR delete  WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD user       ON TABLE papers TYPE record<users>                PERMISSIONS FOR update NONE;
DEFINE FIELD lock       ON TABLE papers TYPE bool DEFAULT true            PERMISSIONS FOR select NONE;
DEFINE FIELD created    ON TABLE papers TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;
DEFINE FIELD resource   ON TABLE papers TYPE record<resources>            PERMISSIONS FOR update NONE;
DEFINE FIELD completed  ON TABLE papers TYPE bool DEFAULT false;

DEFINE FIELD answers    ON TABLE papers TYPE option<array<record>> DEFAULT [];
DEFINE FIELD answers.*  ON TABLE papers TYPE record<answers> ASSERT $value IN (SELECT VALUE id FROM answers WHERE user = user);

-- indexes

-- events
DEFINE EVENT prevent_update ON TABLE papers WHEN $event IS 'UPDATE' THEN {
  IF $auth.id {
    IF $before.lock IS false AND $value.lock IS true { }
    ELSE IF $value.lock IS true { THROW "Should use: fn::on_push($paper_id: record, $answers: option<array<record<answers>>>)"; };
  };

  UPDATE $value SET lock = true; -- auto lock
};

DEFINE EVENT prevent_create ON TABLE papers WHEN $event IS 'CREATE' THEN {
  IF $auth.id {
    IF $value.lock IS false { }
    ELSE IF $value.lock IS true { THROW "Should use: fn::on_push($paper_id: record, $answers: option<array<record<answers>>>)"; };
  };

  UPDATE $value SET lock = true; -- auto lock
};

DEFINE EVENT papers_log ON TABLE papers WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  };
};
