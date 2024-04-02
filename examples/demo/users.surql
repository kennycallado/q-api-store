-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: users
-- ------------------------------

-- pass = '01HK2XYNV155931FMMDAS5M1K8'
UPDATE users:0 SET role = 'admin', pass = '$argon2id$v=19$m=19456,t=2,p=1$8bkXZrpp43P0t4Ux5XLktA$S2Ymwd1iCMKrPtF/Lu5fxRAIByvxhwHZQvDO6ON8uVM';

-- pass = '01HJTEBG4Y1EAXPATENCDCT7WW'
UPDATE users:1 SET role = 'parti', pass = '$argon2id$v=19$m=19456,t=2,p=1$V8T08HLLBA1zbjJuCIqZ6A$S+6semSfdHyeqimOAsIrPZpb+B+FZ6bwxvjm2gTMvUc';

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

