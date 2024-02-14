DEFINE SCOPE user SESSION 1d
  SIGNUP (CREATE users SET username = $username, password = crypto::argon2::generate($password))
  SIGNIN (SELECT * FROM users WHERE crypto::argon2::compare(password, $password))
  ;
