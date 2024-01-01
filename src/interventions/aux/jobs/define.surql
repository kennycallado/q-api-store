-- table
DEFINE TABLE jobs PERMISSIONS NONE;

-- fields
DEFINE FIELD duration ON TABLE jobs TYPE duration;
DEFINE FIELD schedule ON TABLE jobs TYPE string; -- cron like string "* * * * * *"
DEFINE FIELD active   ON TABLE jobs TYPE bool;
DEFINE FIELD status   ON TABLE jobs TYPE option<string> ASSERT $value IN ['scheduled', 'running', 'failed', 'done'];
DEFINE FIELD script   ON TABLE jobs TYPE string; -- script name
DEFINE FIELD since    ON TABLE jobs TYPE option<datetime>;
DEFINE FIELD until    ON TABLE jobs TYPE option<datetime>;

-- indexes

-- events
DEFINE EVENT jobs_log ON TABLE jobs WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};

-- NOTE:
-- -- when use fn::foo() -> freeze
--
-- DEFINE FUNCTION fn::foo($job: record<jobs>) {
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
