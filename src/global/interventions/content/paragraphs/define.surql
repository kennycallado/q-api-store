-- table
DEFINE TABLE paragraphs SCHEMAFULL TYPE NORMAL PERMISSIONS
  FOR select WHERE $auth,
  FOR create, update WHERE $token.role IN ['admin', 'coord', 'thera'],
  FOR delete WHERE $token.role IN ['admin', 'coord']
  ;

DEFINE FIELD type ON TABLE paragraphs TYPE string ASSERT $value INSIDE ['h2', 'h3', 'text'];
DEFINE FIELD ref  ON TABLE paragraphs TYPE string ASSERT $value IS NOT EMPTY VALUE string::slug(string::lowercase($value));
-- DEFINE FIELD ref  ON TABLE paragraphs TYPE string ASSERT $value MATCHES '^([a-z0-9]+-)+[a-z0-9]+$';


DEFINE FIELD content ON TABLE paragraphs TYPE array<object> ASSERT array::len($value) < array::len(SELECT * FROM locales) + 1 AND array::len($value) > 0;
DEFINE FIELD content.*.locale ON TABLE paragraphs TYPE string ASSERT $value IN (SELECT VALUE locale FROM locales);
DEFINE FIELD content.*.text   ON TABLE paragraphs TYPE string ASSERT $value IS NOT EMPTY AND string::len($value) < 250;

-- events
DEFINE EVENT paragraphs_log ON TABLE paragraphs WHEN $event IN ['CREATE', 'UPDATE', 'DELETE'] THEN {
  CREATE logs SET index = $value.id, event = $event, time = time::now();
};
