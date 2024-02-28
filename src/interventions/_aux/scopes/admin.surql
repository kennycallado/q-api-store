# DEFINE SCOPE admin SESSION 1d
#   SIGNIN ( SELECT * FROM users WHERE admin = true AND crypto::argon2::compare(pass, $pass) )
#   ;
