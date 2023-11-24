-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- USERS
-- ------------------------------

DEFINE USER viewer ON DATABASE PASSHASH '$argon2id$v=19$m=19456,t=2,p=1$j5NPoFmfCQ04WdgXEgDpog$lhStYJ7qoN5OCZiiLJJfuHzDfq2JF63PjEVH0KjE/rA' ROLES VIEWER;

