-- Create admin users -- 

UPDATE users:g2 CONTENT { username: 'admin', password: 'admin' };
RELATE users:g2->roled->centers:g1 SET role = 'admin';

UPDATE users:g3 CONTENT { username: 'coord', password: 'coord' };
RELATE users:g3->roled->centers:g1 SET role = 'coord';

UPDATE users:g4 CONTENT { username: 'thera', password: 'thera' };
RELATE users:g4->roled->centers:g1 SET role = 'thera';

RELATE users:g4->join->(SELECT VALUE id FROM ONLY projects WHERE name = 'demo' LIMIT 1);
RELATE users:g4->join->(SELECT VALUE id FROM ONLY projects WHERE name = 'foo' LIMIT 1);

UPDATE users:g5 CONTENT { username: 'thera2', password: 'thera2' };
RELATE users:g5->roled->(SELECT VALUE id FROM ONLY centers WHERE name IS 'demo' LIMIT 1) SET role = 'thera';
RELATE users:g5->roled->(SELECT VALUE id FROM ONLY centers WHERE name IS 'omed' LIMIT 1) SET role = 'coord';

RELATE users:g5->join->(SELECT VALUE id FROM ONLY projects WHERE name = 'demo' LIMIT 1);
RELATE users:g5->join->(SELECT VALUE id FROM ONLY projects WHERE name = 'baz' LIMIT 1);
