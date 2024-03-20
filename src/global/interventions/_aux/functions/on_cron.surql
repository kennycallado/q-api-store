DEFINE FUNCTION fn::on_cron($script: string) {
  LET $script = (SELECT VALUE code FROM ONLY scripts WHERE name = $script LIMIT 1);
  LET $users  = (SELECT VALUE id FROM users WHERE active IS true AND role IS NOT "admin");

  -- maybe if there is no paper for the user just create the actions...
  FOR $user in $users {
    LET $paper = (SELECT * FROM ONLY papers WHERE user = $user ORDER BY created DESC LIMIT 1);
    LET $user = fn::execute_script($script, $user, $paper);

    -- save score
    CREATE scores CONTENT { user: <record> $user.id, score: $user.score };

    -- perform actions
    fn::execute_actions($paper, $user);
  };
};
