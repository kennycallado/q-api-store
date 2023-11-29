DEFINE FUNCTION fn::on_cron($script: string, $users: array<record<users>>) {
  LET $script = (SELECT VALUE code FROM scripts WHERE name = $script)[0];

  -- maybe if there is no paper for the user just create the actions...
  FOR $user in $users {
    LET $paper = (SELECT * FROM papers WHERE user = $user ORDER BY created DESC LIMIT 1)[0];
    LET $user = fn::run_script($user, $script, $paper);

    -- save score
    CREATE scores CONTENT { user: <record> $user.id, score: $user.score };

    -- perform actions
    fn::actions($paper, $user);
  };
};

DEFINE FUNCTION fn::on_push($paper: object) {
  LET $script = (SELECT VALUE code FROM scripts WHERE name = 'push')[0];
  LET $user = fn::run_script($paper.user, $script, $paper);

  -- save score
  CREATE scores CONTENT { user: <record> $user.id, score: $user.score };

  -- perform actions
  RETURN fn::actions($paper, $user);
};

DEFINE FUNCTION fn::run_script($user_id: record<users>, $script: string, $paper: option<object>) {
  -- validation
  -- paper optional because of on_cron could recive users whithout paper

  -- prepare score
  LET $score  = (SELECT * FROM scores WHERE user = $user_id ORDER BY created DESC LIMIT 1).score;

  RETURN function($user_id, $script, $paper, $score[0]) {
    const [user_id, script, paper, score] = arguments;

    const classUser = `class User {
      id;
      score;
      paper;
      actions = [];

      constructor(id, paper, score = {}) {
        // this.id = new Record(...id.split(':')); // this way produces users:⟨1⟩
        this.id = id;
        this.score = score;
        this.paper = paper;
      }
    }`;

    const user = Function(`
      ${classUser};
      const surrealdb = null;
      const user = new User(${JSON.stringify(user_id)}, ${JSON.stringify(paper)}, ${JSON.stringify(score)});
      ${script};

      // user.actions.push({ action: "resource_completed", params: ['module-1'] });
      // user.actions.push({ action: "add_resource", params: ['form-1'] });
      // user.actions.push({ action: "user_unactive", params: [] });
      // user.score = {mood: "100"};

      return user;
    `)();

    return user;
  };
};

-- return the current paper
DEFINE FUNCTION fn::actions($paper: option<object>, $user: object) {
  -- validation
  -- paper could be {}
  -- IF $user.actions = NONE { RETURN $paper };
  -- IF $user.id = NONE { RETURN $paper };

  FOR $action IN $user.actions {
-- resource_completed
    IF $action.action = "resource_completed" {
      FOR $ref IN $action.params {
        -- validation

        -- get resource
        LET $resource_id = (SELECT VALUE id FROM resources WHERE ref = $ref)[0];

        -- update paper
        IF $paper.resource = $resource.id {
          UPDATE $paper.id SET completed = true;
        } ELSE {
          -- can fails if the ref is not found
          UPDATE (SELECT id, created FROM papers WHERE resource = $resource_id ORDER BY created DESC LIMIT 1)[0].id SET completed = true;
        };

      };
    };

-- add_resource
    if $action.action = "add_resource" {
      function($action) { const [action] = arguments; console.log(action) };
      for $ref in $action.params {
        -- validation

        -- get resource
        LET $resource_id = (SELECT VALUE id FROM resources WHERE ref = $ref)[0];

        -- create paper
        -- CREATE papers CONTENT { user: type::thing($user.id), resource: $resource_id };
        CREATE papers CONTENT { user: users:1, resource: resources:1 };

      };
    };

-- user_active
    if $action.action = "user_active" {
      -- validation

      -- send post
      -- http::patch(
      --   'http://localhost:8000/key/users',
      --   { active: true },
      --   { 'Accept': 'application/json', 'NS': 'test', 'DB': 'content' }).result;
    };

-- user_unactive
    if $action.action = "user_unactive" {
      -- validation

      -- send post
      -- http::patch(
      --   'http://localhost:8000/key/users',
      --   { active: false },
      --   { 'Accept': 'application/json', 'NS': 'test', 'DB': 'content' }).result;
    };

-- send_message
    if $action.action = "send_message" {
      -- validation

    };
  };

  RETURN $paper;
};
