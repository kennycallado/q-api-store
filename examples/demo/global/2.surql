-- update admin user
UPDATE users:g2 CONTENT {
    username: 'admin',
    password: 'admin',
    role: 'admin',
};

-- update coord user
UPDATE users:g3 CONTENT {
    username: 'coord',
    password: 'coord',
    role: 'coord',
};

-- update thera user
UPDATE users:g4 CONTENT {
    username: 'thera',
    password: 'thera',
    role: 'thera',
};

USE NS demo DB demo;
UPDATE users:g2 SET pass = crypto::argon2::generate('admin'), role = 'admin', active = false, completed = false;
UPDATE users:g3 SET pass = crypto::argon2::generate('coord'), role = 'coord', active = false, completed = false;
UPDATE users:g4 SET pass = crypto::argon2::generate('thera'), role = 'thera', active = false, completed = false;
USE NS global DB main;

/**
UPDATE users:g2 SET project = projects:g1;
-- UPDATE users:g2 SET project = projects:g2;
-- UPDATE users:g2 SET project = projects:g3;
-- UPDATE users:g2 SET project = projects:g4;
UPDATE users:g2 SET project = NONE;

UPDATE users:g3 SET project = projects:g1;
-- UPDATE users:g3 SET project = projects:g2;
UPDATE users:g3 SET project = NONE;

UPDATE users:g4 SET project = projects:g1;
-- UPDATE users:g4 SET project = projects:g3;
UPDATE users:g4 SET project = NONE;
*/
