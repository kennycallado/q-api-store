-- database level
DEFINE PARAM $project VALUE projects:1;

-- database level
DEFINE USER viewer ON DATABASE PASSWORD 'viewer' ROLES VIEWER;
