DEFINE SCOPE user SESSION 1d
  -- SIGNUP (CREATE users SET pass = crypto::argon2::generate($pass)) -- has no sense
  SIGNIN (SELECT * FROM users WHERE crypto::argon2::compare(pass, $pass))
  ;
