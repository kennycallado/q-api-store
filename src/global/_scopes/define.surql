DEFINE SCOPE user SESSION 1d
  SIGNUP (CREATE users SET username = $username)
  SIGNIN (SELECT * FROM users WHERE username IS $username)
  ;
