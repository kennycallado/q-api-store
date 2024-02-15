
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

-- password = 'kenny'
UPDATE users:1 SET project = projects:1, username = 'kenny', password = '$argon2id$v=19$m=19456,t=2,p=1$PjsR5WMz3chVbsKrmxA3Aw$tl7VqIChZeA9QW5TEh5XAhhgNLrFgKS5/xNsLs4PYoM', web_token = {};

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

