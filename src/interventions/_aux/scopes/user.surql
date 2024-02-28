-- DEFINE SCOPE user SESSION 1d
--   -- SIGNUP (CREATE users SET pass = crypto::argon2::generate($pass)) -- has no sense
--   SIGNIN (SELECT * FROM users WHERE crypto::argon2::compare(pass, $pass))
--   ;

-- manager should inject next line
DEFINE SCOPE user;
-- DEFINE TOKEN user_scope ON SCOPE user TYPE HS256 VALUE "MFFuT3pHb3F1NEhJcGdGVGtIUjJRbmJ2aFNGT0dDZGYw";
-- DEFINE TOKEN demo_user_scope ON SCOPE user TYPE HS256 VALUE (SELECT VALUE token FROM projects WHERE name = "demo");
