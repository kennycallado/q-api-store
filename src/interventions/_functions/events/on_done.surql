DEFINE FUNCTION fn::on_done($user: record<users>) {
  LET $script = (SELECT VALUE code FROM scripts WHERE name = 'done')[0];
  LET $user = fn::execute($script, $user);

  -- save score
  CREATE scores CONTENT { user: <record> $user.id, score: $user.score };

  -- perform actions
  fn::actions($paper, $user);

  -- move the user out of the intervention
};
