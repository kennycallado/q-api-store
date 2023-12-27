-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: projects
-- ------------------------------

UPDATE projects:1 SET name = 'demo';

-- ------------------------------
-- TABLE DATA: users
-- ------------------------------

UPDATE users:1 SET project = projects:1;

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

