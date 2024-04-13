DEFINE FUNCTION fn::on_done($user: record<users>) {
  LET $script = (SELECT VALUE code FROM scripts WHERE name = 'done')[0];
  LET $user = fn::execute_script($script, $user);

  -- save score
  CREATE scores CONTENT { user: <record> $user.id, score: $user.score };

  -- execute actions
  fn::execute_actions($user);
};
