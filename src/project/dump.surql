-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- TABLE: projects
-- ------------------------------

DEFINE TABLE projects SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD brand ON projects TYPE option<string> ASSERT $value = EMPTY OR string::is::url($value);
DEFINE FIELD name ON projects TYPE string;

DEFINE INDEX projects_name_index ON projects FIELDS name UNIQUE;

DEFINE EVENT projects_log ON projects WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: projects
-- ------------------------------


-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

