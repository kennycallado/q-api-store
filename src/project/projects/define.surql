-- table
DEFINE TABLE projects SCHEMAFULL PERMISSIONS NONE;

-- fields
DEFINE FIELD name   ON TABLE projects TYPE string;
DEFINE FIELD state  ON TABLE projects TYPE string ASSERT $value IN ['development', 'production'] DEFAULT 'development';
-- DEFINE FIELD brand  ON TABLE projects TYPE option<string> ASSERT $value IS EMPTY OR string::is::url($value);

-- DEFINE FIELD database        ON TABLE projects TYPE option<object>;
-- DEFINE FIELD database.dbinst ON TABLE projects TYPE option<string>;
-- DEFINE FIELD database.domain ON TABLE projects TYPE option<string>;

-- indexes
DEFINE INDEX projects_name_index ON projects FIELDS name UNIQUE;

-- events
DEFINE EVENT projects_log ON TABLE projects WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  }
};
