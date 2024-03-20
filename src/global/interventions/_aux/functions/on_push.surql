DEFINE FUNCTION fn::on_push($paper_id: record<papers>, $answers: option<array<record<answers>>>) {
  -- get paper
  LET $paper = (SELECT * FROM $paper_id)[0];

  -- save answers in case
  IF $answers != NONE { $paper = (UPDATE $paper_id SET lock = false, answers = $answers)[0] };

  -- get script and execute it -> returns user (with score and actions)
  LET $script = (SELECT VALUE code FROM scripts WHERE name = 'push')[0];
  LET $user = fn::execute_script($script, $paper.user, $paper);

  -- save score
  CREATE scores CONTENT { user: <record> $user.id, score: $user.score };

  -- execute actions
  fn::execute_actions($paper, $user);
};
