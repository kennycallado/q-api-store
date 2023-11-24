-- table
DEFINE TABLE projects SCHEMAFULL PERMISSIONS NONE;

-- fields
DEFINE FIELD name   ON TABLE projects TYPE string;
DEFINE FIELD brand  ON TABLE projects TYPE option<string> ASSERT $value IS EMPTY OR string::is::url($value);

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
