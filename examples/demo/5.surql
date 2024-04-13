-- Update admin users in demo --

-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

USE NS demo DB demo;

-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: users
-- ------------------------------

UPDATE users:g2 SET pass = crypto::argon2::generate('admin'), role = 'admin', active = false, completed = false;
UPDATE users:g3 SET pass = crypto::argon2::generate('coord'), role = 'coord', active = false, completed = false;
UPDATE users:g4 SET pass = crypto::argon2::generate('thera'), role = 'thera', active = false, completed = false;

-- pass = '01HK2XYNV155931FMMDAS5M1K8'
-- UPDATE users:0 SET role = 'admin', active = false, completed = false, pass = '$argon2id$v=19$m=19456,t=2,p=1$8bkXZrpp43P0t4Ux5XLktA$S2Ymwd1iCMKrPtF/Lu5fxRAIByvxhwHZQvDO6ON8uVM';

-- pass = '01HJTEBG4Y1EAXPATENCDCT7WW'
-- UPDATE users:1 SET role = 'parti', active = false, completed = false, pass = '$argon2id$v=19$m=19456,t=2,p=1$V8T08HLLBA1zbjJuCIqZ6A$S+6semSfdHyeqimOAsIrPZpb+B+FZ6bwxvjm2gTMvUc';

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

USE NS global DB main;
