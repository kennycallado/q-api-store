UPDATE centers:g1  SET name = 'demo';
UPDATE projects:g1 SET center = centers:g1, name = 'demo', keys = ['step', 'state'];
