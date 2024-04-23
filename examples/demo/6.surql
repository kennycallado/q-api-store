-- Create rest of the users --

-- UPDATE users:g10 SET username = rand::string(), password = rand::string(), project = projects:g1;

-- known users:
UPDATE users:g10 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
UPDATE users:g20 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
UPDATE users:g30 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };

FOR $project IN (SELECT VALUE id FROM projects) {
  FOR $i IN [0,1,2,3,4,5,6,7,8,9] { 
    CREATE users CONTENT {
      username: rand::string(),
      password: rand::string(),
      project: $project
    };

    -- sleep(100ms);
  };
};

-- UPDATE users:g11 CONTENT { username: rand::string(), password: rand::string(), project: (SELECT VALUE id FROM ONLY projects WHERE name = 'foo'  LIMIT 1) };
-- UPDATE users:g12 CONTENT { username: rand::string(), password: rand::string(), project: (SELECT VALUE id FROM ONLY projects WHERE name = 'bar'  LIMIT 1) };
-- UPDATE users:g13 CONTENT { username: rand::string(), password: rand::string(), project: (SELECT VALUE id FROM ONLY projects WHERE name = 'baz'  LIMIT 1) };
-- 
-- -- UPDATE users:g14 SET username = rand::string(), password = rand::string(), project = projects:g1;
-- UPDATE users:g14 CONTENT { username: rand::string(), password: rand::string(), project: (SELECT VALUE id FROM ONLY projects WHERE name = 'demo' LIMIT 1) };
-- UPDATE users:g15 CONTENT { username: rand::string(), password: rand::string(), project: (SELECT VALUE id FROM ONLY projects WHERE name = 'foo'  LIMIT 1) };
-- UPDATE users:g16 CONTENT { username: rand::string(), password: rand::string(), project: (SELECT VALUE id FROM ONLY projects WHERE name = 'bar'  LIMIT 1) };
-- UPDATE users:g17 CONTENT { username: rand::string(), password: rand::string(), project: (SELECT VALUE id FROM ONLY projects WHERE name = 'baz'  LIMIT 1) };
-- 
-- -- UPDATE users:g18 SET username = rand::string(), password = rand::string(), project = projects:g1;
-- UPDATE users:g18 CONTENT { username: rand::string(), password: rand::string(), project: (SELECT VALUE id FROM ONLY projects WHERE name = 'demo' LIMIT 1) };
-- UPDATE users:g19 CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
