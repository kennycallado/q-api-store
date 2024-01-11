DEFINE FUNCTION fn::on_push($paper_id: record, $answers: option<array<record<answers>>>) {
  LET $script = (SELECT VALUE code FROM scripts WHERE name = 'push')[0];
  LET $paper  = (UPDATE $paper_id set answers = $answers, lock = false)[0];

  LET $user = fn::execute($script, $paper.user, $paper);

  -- save score
  CREATE scores CONTENT { user: <record> $user.id, score: $user.score };

  -- perform actions
  LET $result = fn::actions($paper, $user);

  function($result) {const [result] = arguments; console.error({result})};

  -- lock the paper
  UPDATE $paper_id set lock = true
};
