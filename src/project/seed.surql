
-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: project/projects
-- ------------------------------

UPDATE projects:1 CONTENT { name: "demo", dbname: "demo" }

-- ------------------------------
-- TABLE DATA: project/users
-- ------------------------------

UPDATE users:1 CONTENT { active: true, project: projects:1 }

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

