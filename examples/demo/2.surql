-- Create admin users -- 

UPDATE users:g2 CONTENT { username: 'admin', password: 'admin', role: 'admin' };
UPDATE users:g3 CONTENT { username: 'coord', password: 'coord', role: 'coord' };
UPDATE users:g4 CONTENT { username: 'thera', password: 'thera', role: 'thera' };

UPDATE users:g2 SET project = (SELECT VALUE id FROM ONLY projects WHERE name = 'demo' LIMIT 1);
UPDATE users:g2 SET project = (SELECT VALUE id FROM ONLY projects WHERE name = 'foo'  LIMIT 1);
UPDATE users:g2 SET project = (SELECT VALUE id FROM ONLY projects WHERE name = 'bar'  LIMIT 1);
UPDATE users:g2 SET project = (SELECT VALUE id FROM ONLY projects WHERE name = 'baz'  LIMIT 1);
UPDATE users:g2 SET project = NONE;

UPDATE users:g3 SET project = (SELECT VALUE id FROM ONLY projects WHERE name = 'demo' LIMIT 1);
UPDATE users:g3 SET project = (SELECT VALUE id FROM ONLY projects WHERE name = 'foo'  LIMIT 1);
UPDATE users:g3 SET project = NONE;

UPDATE users:g4 SET project = (SELECT VALUE id FROM ONLY projects WHERE name = 'demo' LIMIT 1);
UPDATE users:g4 SET project = (SELECT VALUE id FROM ONLY projects WHERE name = 'bar'  LIMIT 1);
UPDATE users:g4 SET project = NONE;
