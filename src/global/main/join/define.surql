-- table
DEFINE TABLE join SCHEMALESS PERMISSIONS
  FOR select, create, update, delete WHERE $auth
  ;

-- index to enforce unique join
DEFINE INDEX unique_join ON TABLE join COLUMNS in, out UNIQUE;
