-- table
DEFINE TABLE resources SCHEMAFULL PERMISSIONS
  FOR select WHERE $auth.id;

-- fields
-- ref should be with the project id
DEFINE FIELD ref          ON TABLE resources TYPE string ASSERT $value IS NOT EMPTY VALUE string::slug($value);
DEFINE FIELD description  ON TABLE resources TYPE string;
DEFINE FIELD title        ON TABLE resources TYPE string ASSERT $value IS NOT EMPTY;
DEFINE FIELD type         ON TABLE resources TYPE string ASSERT $value INSIDE ['slides','module','form','external'];

-- -- form
DEFINE FIELD form   ON TABLE resources TYPE option<array<record>> ASSERT $value IS NONE OR type = 'form' AND array::len($value) > 0;
DEFINE FIELD form.* ON TABLE resources TYPE record<questions>;

-- -- module
DEFINE FIELD module   ON TABLE resources TYPE option<array<record>> ASSERT $value IS NONE OR type = 'module' AND array::len($value) > 0;
DEFINE FIELD module.* ON TABLE resources TYPE record<slides>;

-- -- slides
DEFINE FIELD slides ON TABLE resources TYPE option<array<record>> ASSERT $value IS NONE OR type = 'slides' AND array::len($value) > 0;
DEFINE FIELD slides.* ON TABLE resources TYPE record<slides>;

-- indexes
DEFINE INDEX resources_ref_unique ON TABLE resources FIELDS ref UNIQUE;

-- events
-- DEFINE EVENT p_create_resource ON TABLE resources WHEN $event = "CREATE" THEN {
--   RELATE $project->create_resource->$value;
-- };

DEFINE EVENT resources_log ON TABLE resources WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
