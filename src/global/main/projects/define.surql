-- table
DEFINE TABLE projects SCHEMAFULL PERMISSIONS 
  FOR select, create, update, delete WHERE $auth
  ;

-- fields
DEFINE FIELD name   ON TABLE projects TYPE string;
DEFINE FIELD state  ON TABLE projects TYPE string ASSERT $value IN ['development', 'testing', 'production', 'finished'] DEFAULT 'development';
DEFINE FIELD token  ON TABLE projects TYPE option<string> ASSERT $input IS NONE VALUE $before OR rand::string(33);
DEFINE FIELD center ON TABLE projects TYPE record<centers>;

DEFINE FIELD settings ON TABLE projects FLEXIBLE TYPE option<object> DEFAULT {};
DEFINE FIELD settings.url ON TABLE projects TYPE option<string> ASSERT $value IS EMPTY OR string::is::url($value);

-- indexes
DEFINE INDEX name_index ON TABLE projects FIELDS name UNIQUE;

-- events
DEFINE EVENT projects_log ON TABLE projects WHEN $event = "CREATE" OR $event = "UPDATE" OR $event = "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id,  event = $event, time = time::now();
  }
};
