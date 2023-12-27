DEFINE FUNCTION fn::on_push($paper: object) {
  LET $script = (SELECT VALUE code FROM scripts WHERE name = 'push')[0];
  LET $user = fn::execute($script, $paper.user, $paper);

  -- save score
  CREATE scores CONTENT { user: <record> $user.id, score: $user.score };

  -- perform actions
  RETURN fn::actions($paper, $user);
};
