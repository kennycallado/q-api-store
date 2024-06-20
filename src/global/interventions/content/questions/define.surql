-- table
DEFINE TABLE questions SCHEMAFULL TYPE NORMAL PERMISSIONS
  FOR select WHERE $auth,
  FOR create, update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

-- fields
DEFINE FIELD ref   ON TABLE questions TYPE string ASSERT $value IS NOT EMPTY VALUE string::slug(string::lowercase($value));
DEFINE FIELD type  ON TABLE questions TYPE string ASSERT $value INSIDE ['range', 'text'];

-- -- question
-- waiting for between
DEFINE FIELD content ON TABLE questions TYPE object ASSERT $value IS NOT EMPTY;
DEFINE FIELD content.questions ON TABLE questions TYPE array<object> ASSERT array::len($value) < array::len(SELECT * FROM locales) + 1 AND array::len($value) > 0;
DEFINE FIELD content.questions.*.locale   ON TABLE questions TYPE string ASSERT $value IN (SELECT VALUE locale FROM locales);
DEFINE FIELD content.questions.*.question ON TABLE questions TYPE string ASSERT $value IS NOT EMPTY AND string::len($value) < 250;

DEFINE FIELD content.questions.*.spelled  ON TABLE questions TYPE option<array<string>> ASSERT $value IS EMPTY OR type = 'range';
-- -- range
DEFINE FIELD content.range       ON TABLE questions TYPE option<object> ASSERT $value IS NONE OR type = 'range';
DEFINE FIELD content.range.max   ON TABLE questions TYPE option<number> ASSERT $value IS NONE OR content.range IS NOT NONE;
DEFINE FIELD content.range.min   ON TABLE questions TYPE option<number> ASSERT $value IS NONE OR content.range IS NOT NONE;
DEFINE FIELD content.range.value ON TABLE questions TYPE option<number> ASSERT $value IS NONE OR content.range IS NOT NONE;

-- -- text
DEFINE FIELD content.text       ON TABLE questions TYPE option<object> ASSERT $value IS NONE OR type = 'text';
DEFINE FIELD content.text.max   ON TABLE questions TYPE option<number> ASSERT $value IS NONE OR content.text IS NOT NONE;
DEFINE FIELD content.text.min   ON TABLE questions TYPE option<number> ASSERT $value IS NONE OR content.text IS NOT NONE;

-- indexes

-- events
DEFINE EVENT questions_log ON TABLE questions WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  CREATE logs SET index = $value.id, event = $event, time = time::now();
};
