-- table
DEFINE TABLE users SCHEMAFULL TYPE NORMAL PERMISSIONS
  FOR select, create, update, delete WHERE $auth
  ;
  -- FOR select WHERE id = $auth OR $token.role IN ['robot', 'admin', 'coord']

-- fields
DEFINE FIELD username ON TABLE users TYPE string PERMISSIONS FOR update NONE;
DEFINE FIELD password ON TABLE users TYPE string VALUE $before OR crypto::argon2::generate($value) PERMISSIONS FOR select, update NONE;
DEFINE FIELD project  ON TABLE users TYPE option<record<projects> | null> PERMISSIONS
  FOR update WHERE $token.role IS 'admin'
    OR $token.role IS 'coord' AND $value IS null
    OR $token.role IS 'coord' AND $value IN (SELECT VALUE ->roled->centers<-belongs<-projects FROM ONLY $auth)
    OR $token.role IS 'thera' AND $value IS null
    OR $token.role IS 'thera' AND $value IN (SELECT VALUE ->join->projects FROM ONLY $auth);

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

-- DEFINE EVENT users_join ON TABLE users WHEN $event IN ['CREATE', 'UPDATE'] THEN {
--   IF $value.project IS NOT NONE {
--     LET $id = $value.id;
--     LET $project = $value.project;
-- 
--     -- check if the user is already in the project
--     IF (SELECT id FROM join WHERE in = $id AND out = $project) {
--       UPDATE join SET updated = time::now() WHERE in = $id AND out = $project;
--     } ELSE {
--       RELATE $id->join->$project;
--     };
--   };

  -- in case to control exit
  -- ELSE IF $before.project IS NOT NONE {
  --   LET $id = $value.id;
  --   LET $project = $before.project;
  --   -- RELATE $id->join->$project CONTENT { exit: true, updated: time::now() };
  --   UPDATE join SET updated = time::now() WHERE in = $id AND out = $project;
  -- };
-- };
