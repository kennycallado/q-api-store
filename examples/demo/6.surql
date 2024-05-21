-- Create rest of the users --

DEFINE FUNCTION fn::foo($user: record<users>, $center: string, $project: string) {
  RELATE $user->roled->(SELECT VALUE id FROM ONLY centers WHERE name IS $center  LIMIT 1) SET role = 'parti';
  RELATE $user->join->(SELECT VALUE id FROM ONLY projects WHERE name IS $project LIMIT 1);
};

-- known users
fn::foo((UPDATE users:g10 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 })[0].id, 'demo', 'demo');
fn::foo((UPDATE users:g20 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 })[0].id, 'demo', 'demo');
fn::foo((UPDATE users:g30 CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 })[0].id, 'demo', 'demo');

FOR $time IN [0,1,2,3,4,5,6,7,8,9] {
  -- fn::foo((CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 })[0].id, 'demo', 'demo');
  LET $user = (CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 })[0].id;
  RELATE $user->roled->(SELECT VALUE id FROM ONLY centers WHERE name IS 'demo' LIMIT 1) SET role = 'parti';
  RELATE $user->join->(SELECT VALUE id FROM ONLY projects WHERE name IS 'demo' LIMIT 1);
};

FOR $time IN [0,1,2,3,4,5,6,7,8,9] {
  -- fn::foo((CREATE users CONTENT { username: rand::string(), password: rand::string() })[0].id, 'demo', 'foo');
  LET $user = (CREATE users CONTENT { username: rand::string(), password: rand::string(), project: projects:g1 })[0].id;
  RELATE $user->roled->(SELECT VALUE id FROM ONLY centers WHERE name IS 'demo' LIMIT 1) SET role = 'parti';
  RELATE $user->join->(SELECT VALUE id FROM ONLY projects WHERE name IS 'foo' LIMIT 1);
};

FOR $time IN [0,1,2,3,4,5,6,7,8,9] {
  fn::foo((CREATE users CONTENT { username: rand::string(), password: rand::string() })[0].id, 'omed', 'bar');
};

FOR $time IN [0,1,2,3,4,5,6,7,8,9] {
  fn::foo((CREATE users CONTENT { username: rand::string(), password: rand::string() })[0].id, 'omed', 'baz');
};

REMOVE FUNCTION fn::foo;
