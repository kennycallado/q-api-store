RETURN 'hello';
/**
UPDATE centers:g1  SET name = 'demo';
UPDATE projects:g1 SET center = centers:g1, name = 'demo', keys = ['step', 'state'];

-- wait for supervisor to spawn the listener
-- SLEEP 1s;

-- create and update other centers and projects
-- UPDATE projects:g2 SET center = centers:g1, name = 'foo', keys = ['step'];

-- UPDATE centers:g2  SET name = 'omed';
-- UPDATE projects:g3 SET center = centers:g2, name = 'bar';
-- UPDATE projects:g4 SET center = centers:g2, name = 'baz';

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

-- 
UPDATE users:g2 SET project = projects:g1;
-- UPDATE users:g2 SET project = projects:g2;
-- UPDATE users:g2 SET project = projects:g3;
-- UPDATE users:g2 SET project = projects:g4;
-- UPDATE users:g2 SET project = NONE;

UPDATE users:g3 SET project = projects:g1;
-- UPDATE users:g3 SET project = projects:g2;
-- UPDATE users:g3 SET project = NONE;

UPDATE users:g4 SET project = projects:g1;
-- UPDATE users:g4 SET project = projects:g3;
-- UPDATE users:g4 SET project = NONE;

--
UPDATE users:g10 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
-- UPDATE users:g11 CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
-- UPDATE users:g12 CONTENT { username: rand::string(), password: rand::string(), project: projects:g3 };
-- UPDATE users:g13 CONTENT { username: rand::string(), password: rand::string(), project: projects:g4 };
UPDATE users:g14 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
-- UPDATE users:g15 CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
-- UPDATE users:g16 CONTENT { username: rand::string(), password: rand::string(), project: projects:g3 };
-- UPDATE users:g17 CONTENT { username: rand::string(), password: rand::string(), project: projects:g4 };
UPDATE users:g18 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
-- UPDATE users:g19 CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };

--
-- USE NS demo DB foo;
-- UPDATE users:g2 SET pass = crypto::argon2::generate('admin'), role = 'admin', active = false, completed = false;
-- UPDATE users:g2 SET pass = crypto::argon2::generate('coord'), role = 'coord', active = false, completed = false;
-- 
-- USE NS omed DB bar;
-- UPDATE users:g2 SET pass = crypto::argon2::generate('admin'), role = 'admin', active = false, completed = false;
-- UPDATE users:g4 SET pass = crypto::argon2::generate('thera'), role = 'thera', active = false, completed = false;
-- 
-- USE NS omed DB baz;
-- UPDATE users:g2 SET pass = crypto::argon2::generate('admin'), role = 'admin', active = false, completed = false;
*/
