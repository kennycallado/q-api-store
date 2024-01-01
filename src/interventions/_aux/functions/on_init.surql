DEFINE FUNCTION fn::on_init($user: record<users>) {
  LET $script = (SELECT VALUE code FROM scripts WHERE name = 'init')[0];
  LET $user = fn::execute($script, $user);

  -- save score
  CREATE scores CONTENT { user: <record> $user.id, score: $user.score };

  -- perform actions
  fn::actions($paper, $user);
};
