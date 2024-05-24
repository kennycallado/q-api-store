-- Create centers and projects --

-- Create center demo and projects g1 and g2
UPDATE centers:g1  SET name = 'demo';
UPDATE projects:g1 SET center = centers:g1, name = 'demo', keys = ['step', 'state'];
UPDATE projects:g2 SET center = centers:g1, name = 'foo', keys = ['step'];

-- Create center omed and projects bar and baz
CREATE centers SET name = 'omed';
CREATE projects SET center = (SELECT VALUE id FROM ONLY centers WHERE name = 'omed' LIMIT 1), name = 'bar', keys = ['step'];
CREATE projects SET center = (SELECT VALUE id FROM ONLY centers WHERE name = 'omed' LIMIT 1), name = 'baz', keys = ['step'];

-- because of the supervisor
SLEEP 1s;
