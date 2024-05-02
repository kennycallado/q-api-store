-- Create rest of the users --

-- known users
UPDATE users:g10 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
UPDATE users:g20 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
UPDATE users:g30 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };

-- unknown users for projects:g1
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 };

-- unknown users for projects:g2
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g2 };

-- unknown users for projects:g3
LET $project = (SELECT VALUE id FROM ONLY projects WHERE name = 'bar' LIMIT 1);
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };

-- unknown users for projects:g4
LET $project = (SELECT VALUE id FROM ONLY projects WHERE name = 'baz' LIMIT 1);
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
CREATE users CONTENT { username: rand::string(), password: rand::string(), project: $projects };
