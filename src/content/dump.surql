-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- USERS
-- ------------------------------

DEFINE USER viewer ON DATABASE PASSHASH '$argon2id$v=19$m=19456,t=2,p=1$lcrWfYQFNOe0ab+VE/8Scg$ulYkGtGVGxArM9GAK7qAGgKhrc6tEPAVLHgmmJFjgko' ROLES VIEWER;

