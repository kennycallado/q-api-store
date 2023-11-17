-- table
DEFINE TABLE questions SCHEMAFULL PERMISSIONS NONE;

-- fields
DEFINE FIELD type   ON TABLE questions TYPE string ASSERT $value INSIDE ['range', 'input'];
DEFINE FIELD range  ON TABLE questions TYPE option<object> ASSERT $value IS NONE OR type = 'range';

-- -- range
DEFINE FIELD range.min    ON TABLE questions TYPE option<number> ASSERT $value IS NONE OR range IS NOT NONE;
DEFINE FIELD range.max    ON TABLE questions TYPE option<number> ASSERT $value IS NONE OR range IS NOT NONE;
DEFINE FIELD range.value  ON TABLE questions TYPE option<number> ASSERT $value IS NONE OR range IS NOT NONE;

-- -- question
DEFINE FIELD question ON TABLE questions TYPE array<object> ASSERT array::len($value) < 4 AND array::len($value) > 0;
DEFINE FIELD question.*         ON TABLE questions TYPE object;
DEFINE FIELD question.*.locale  ON TABLE questions TYPE string ASSERT $value IN (SELECT VALUE locale FROM locales);
DEFINE FIELD question.*.content ON TABLE questions TYPE string ASSERT $value IS NOT EMPTY AND string::len($value) < 250;

-- indexes
-- DEFINE INDEX questions_ref_index ON questions FIELDS ref UNIQUE;

-- events
DEFINE EVENT p_create_question ON TABLE questions WHEN $event = "CREATE" THEN {
  RELATE $project->create_question->$value;
};

DEFINE EVENT questions_log ON TABLE questions WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
