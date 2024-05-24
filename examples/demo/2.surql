-- ??

DEFINE FUNCTION fn::foo($user: record<users>, $center: string, $project: string, $role: string) {
  RELATE $user->roled->(SELECT VALUE id FROM ONLY centers WHERE name IS $center  LIMIT 1) SET role = $role;
  RELATE $user->join->(SELECT VALUE id FROM ONLY projects WHERE name IS $project LIMIT 1);
};

REMOVE FUNCTION fn::foo;
