-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- USERS
-- ------------------------------

DEFINE USER viewer ON DATABASE PASSHASH '$argon2id$v=19$m=19456,t=2,p=1$EizSCXI5fmNhbXWc/MIf6A$MejhK64KIcLcwjbq9DndLqKkyoEJ722AkurGWt22EHc' ROLES VIEWER;

