-- table
DEFINE TABLE users SCHEMAFULL TYPE NORMAL PERMISSIONS
  FOR select, create, update, delete WHERE $auth
  ;
  -- FOR select WHERE id = $auth OR $token.role IN ['robot', 'admin', 'coord']

-- fields
DEFINE FIELD username ON TABLE users TYPE string PERMISSIONS FOR update NONE;
DEFINE FIELD password ON TABLE users TYPE string VALUE $before OR crypto::argon2::generate($value) PERMISSIONS FOR select, update NONE;
DEFINE FIELD project  ON TABLE users TYPE option<record<projects>>
  ASSERT ($value IS NONE)
    OR ($value IN SELECT VALUE out FROM join WHERE in IS $parent.id)
    OR ($value IN (SELECT VALUE (SELECT VALUE in FROM belongs WHERE out IS $parent.out) FROM roled WHERE role IN ['admin', 'coord'] AND in IS $parent.id)[0])
    ;

-- DEFINE FIELD roles    ON TABLE users VALUE <future> { RETURN (SELECT out as center, role FROM roled WHERE in IS $parent.id) };
-- DEFINE FIELD role     ON TABLE users TYPE option<string> ASSERT $value IN ['robot', 'admin', 'coord', 'thera', 'parti', 'guest'] DEFAULT 'parti' PERMISSIONS FOR update NONE;

-- DEFINE FIELD devices ON users TYPE array<record<devices>>;
DEFINE FIELD web_token ON TABLE users FLEXIBLE TYPE option<object> DEFAULT {} PERMISSIONS FOR select NONE;
DEFINE FIELD web_token.endpoint    ON TABLE users TYPE option<string>;
DEFINE FIELD web_token.keys        ON TABLE users TYPE option<object>;
DEFINE FIELD web_token.keys.auth   ON TABLE users TYPE option<string>;
DEFINE FIELD web_token.keys.p256dh ON TABLE users TYPE option<string>;

-- indexes
DEFINE INDEX username_index ON TABLE users FIELDS username UNIQUE;

-- events
DEFINE EVENT users_log ON TABLE users WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  CREATE logs SET index = $value.id,  event = $event, time = time::now();
};
