-- not sure if SIGNUP has sense
  -- SIGNUP ( CREATE users SET pass = crypto::argon2::generate($pass) )

DEFINE SCOPE user SESSION 1d
  SIGNIN ( SELECT * FROM users WHERE crypto::argon2::compare(pass, $pass) )
  ;
