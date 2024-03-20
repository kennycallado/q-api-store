-- DEFINE SCOPE user SESSION 1d
--   SIGNUP (CREATE users SET username = $username)
--   SIGNIN (SELECT * FROM users WHERE username IS $username)
--   ;

DEFINE SCOPE user;
-- DEFINE TOKEN user_scope ON SCOPE user TYPE HS256 VALUE "MFFuT3pHb3F1NEhJcGdGVGtIUjJRbmJ2aFNGT0dDZGYw";
