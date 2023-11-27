-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- TABLE: projects
-- ------------------------------

DEFINE TABLE projects SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD name ON projects TYPE string;
DEFINE FIELD state ON projects TYPE string DEFAULT 'development' ASSERT $value INSIDE ['development', 'production'];

DEFINE INDEX projects_name_index ON projects FIELDS name UNIQUE;

DEFINE EVENT projects_log ON projects WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TABLE: users
-- ------------------------------

DEFINE TABLE users SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD active ON users TYPE bool DEFAULT false;
DEFINE FIELD project ON users TYPE record<projects> ASSERT $value INSIDE (SELECT VALUE id FROM projects);

DEFINE EVENT users_log ON users WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: projects
-- ------------------------------


-- ------------------------------
-- TABLE DATA: users
-- ------------------------------


-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

