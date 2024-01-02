DEFINE FUNCTION fn::on_cron($script: string) {
  LET $script = (SELECT VALUE code FROM scripts WHERE name = $script)[0];
  LET $users  = (SELECT VALUE id FROM users);

  -- maybe if there is no paper for the user just create the actions...
  FOR $user in $users {
    -- prevent include admins
    IF $user.admin { CONTINUE };

    LET $paper = (SELECT * FROM papers WHERE user = $user ORDER BY created DESC LIMIT 1)[0];
    LET $user = fn::execute($script, $user, $paper);

    -- save score
    CREATE scores CONTENT { user: <record> $user.id, score: $user.score };

    -- perform actions
    fn::actions($paper, $user);
  };
};
