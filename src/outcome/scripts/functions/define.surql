DEFINE FUNCTION fn::on_push($paper: object) {
  -- ensure argument is a paper object
  IF meta::tb($paper.id) != "papers" { THROW "\n\tArgument is not a paper" };

  LET $script = (SELECT VALUE code FROM scripts WHERE name = "push")[0];
  LET $user   = fn::run_script($script, $paper);

  -- execute actions
  RETURN fn::actions($paper, $user);
};

DEFINE FUNCTION fn::run_script($script: string, $paper: object) {
  -- prepare score
  LET $score  = (SELECT * FROM scores WHERE user = $paper.user ORDER BY created DESC LIMIT 1).score;

  RETURN function($script, $paper, $score[0]) {
    const [script, paper, score] = arguments;

    const classUser = `class User {
      id;
      score;
      paper;
      actions = [];

      constructor(paper, score = {}) {
        this.id = paper.user;
        this.score = score;
        this.paper = paper;
      }
    }`;

    const user = Function(`
      ${classUser};
      const surrealdb = null;
      const user = new User(${JSON.stringify(paper)}, ${JSON.stringify(score)});
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

DEFINE FUNCTION fn::actions($paper: object, $user: object) {
  -- save score
  CREATE scores CONTENT {
    user: $paper.user,
    score: $user.score
  };

  -- prepare resources
  LET $resources = http::get(
    'http://localhost:8000/key/resources',
    { 'Accept': 'application/json', 'NS': 'test', 'DB': 'content' }).result;

  -- validation
  IF $user.actions = NONE { RETURN $paper };

  FOR $action IN $user.actions {

-- resource_completed
    IF $action.action = "resource_completed" {
      FOR $ref IN $action.params {
        -- validation

        -- get resource
        LET $resource = (SELECT * FROM $resources[0] WHERE ref = $ref)[0];

        -- update paper
        IF $paper.resource = $resource.id {
          UPDATE $paper.id SET completed = true;
        } ELSE {
          -- can fails if the ref is not found
          UPDATE (SELECT id, created FROM papers WHERE resource = $resource.id ORDER BY created DESC LIMIT 1)[0].id SET completed = true;
        };

      };
    };

-- add_resource
    if $action.action = "add_resource" {
      for $ref in $action.params {
        -- validation

        -- get resource
        LET $resource = (SELECT * FROM $resources[0] WHERE ref = $ref)[0];

        -- create paper
        CREATE papers CONTENT {
          user: $paper.user,
          resource: $resource.id
        };

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
