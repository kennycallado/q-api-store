-- table
DEFINE TABLE events SCHEMAFULL TYPE NORMAL PERMISSIONS
  -- FOR select WHERE $auth
  FOR select, create, update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD schedule ON TABLE events TYPE string; -- cron like string "* * * * * *"
DEFINE FIELD script   ON TABLE events TYPE string ASSERT $value IN (SELECT VALUE name FROM scripts); -- script name
DEFINE FIELD active   ON TABLE events TYPE bool DEFAULT false;   -- is the event active
DEFINE FIELD since    ON TABLE events TYPE option<datetime>;
DEFINE FIELD until    ON TABLE events TYPE option<datetime>;

-- should use jobs table
DEFINE FIELD job_id   ON TABLE events TYPE option<uuid> DEFAULT NONE; -- job id
DEFINE FIELD status   ON TABLE events TYPE option<string> ASSERT $value IS NONE OR $value IN ['scheduled', 'running', 'failed', 'done'];

-- indexes

-- events
DEFINE EVENT events_log ON TABLE events WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};

-- https://github.com/surrealdb/surrealdb/issues/192 --

-- DEFINE USER username ON ROOT PASSWORD '123456' ROLES OWNER;
-- UPDATE events:1 SET schedule = "0/5 * * * * *", active = true, script = "foo", status = "scheduled", duration = 5s;
-- DEFINE FUNCTION fn::foo($job: record<events>) {
--   LET $job = (SELECT * FROM $job)[0];
--   -- LET $sql = "SLEEP "+ type::string($job.duration) +"; SELECT * FROM "+ type::string($job.id);
-- 
--   LET $sql = "SELECT * FROM "+ type::string($job.id);
-- 
--   -- function($sql) { const [sql] = arguments; console.log({sql}) };
-- 
--   sleep($job.duration);
--   LET $result = http::post(
--     'http://localhost:8000/sql',
--     <bytes> $sql,
--     {
--       "DB": "demo",
--       "NS": "interventions",
--       "Accept": "application/json",
--       "Authorization": "Basic dXNlcm5hbWU6MTIzNDU2"
--     }).result;
-- 
--   function($result) { const [result] = arguments; console.log(`result: ${ JSON.stringify(result) }`) };
--   
--   IF $result[1][0].active = true { fn::foo($job.id) };
-- } PERMISSIONS FULL;

-- NOTE:
-- -- when use fn::foo() -> freeze
--
-- DEFINE FUNCTION fn::foo($job: record<events>) {
--   -- sleep needs extra permissions
--   -- DEFINE USER username ON ROOT PASSWORD '123456' ROLES OWNER;
-- 
--   LET $job = (SELECT * FROM $job)[0];
--   LET $sql  = "SELECT * FROM locales; " + "SLEEP " + type::string($job.duration) + "; " +
--     "LET $blah = (SELECT * FROM"+ type::string($job.id) +")[0];" +
--     "IF $blah.active = true { fn::foo($blah.id) };"
--     ;
-- 
--   -- LET $sql = "SLEEP 10s; LET $blah = (SELECT * FROM "+ type::string($job.id) +")[0]; IF $blah.active = true { function() { console.log('hola') }; };";
-- 
--   LET $sql = "SLEEP "+ type::string($job.duration) +"; SELECT * FROM "+ type::string($job.id);
-- 
--   -- function($job) { const [job] = arguments; console.log({job}) };
-- 
--   LET $result = http::post(
--     'http://localhost:8000/sql',
--     <bytes> $sql,
--     {
--       "DB": "demo",
--       "NS": "interventions",
--       "Accept": "application/json",
--       "Authorization": "Basic dXNlcm5hbWU6MTIzNDU2"
--     }).result;
-- 
--   IF $result[1][0].active = true { fn::foo($job.id) };
-- 
--   function($result) { const [result] = arguments; console.log(`result: ${ JSON.stringify(result) }`) };
-- };
