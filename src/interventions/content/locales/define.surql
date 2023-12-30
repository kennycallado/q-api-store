-- table
DEFINE TABLE locales SCHEMAFULL PERMISSIONS
  FOR select WHERE $auth.id;

-- fields
-- -- ISO 639-1
DEFINE FIELD locale ON TABLE locales TYPE string ASSERT string::len($value) = 2;

-- indexes

-- events
-- DEFINE EVENT p_create_locale ON TABLE locales WHEN $event = "CREATE" THEN {
--   RELATE $project->create_locale->$value;
-- };

DEFINE EVENT locales_log ON TABLE locales WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
