-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- FUNCTIONS
-- ------------------------------

DEFINE FUNCTION fn::actions($paper: object, $user: object) {
FOR $action IN $user.actions {
IF $action.action = 'resource_completed' { FOR $ref IN $action.params {
LET $resource_id = (SELECT VALUE id FROM resources WHERE ref = $ref)[0];
IF $paper.resource = $resource.id {
UPDATE $paper.id SET completed = true;
$paper.completed = true;
} ELSE { UPDATE (SELECT id, created FROM papers WHERE resource = $resource_id ORDER BY created DESC LIMIT 1)[0].id SET completed = true; };
}; };
IF $action.action = 'add_resource' {
function($action) { const [action] = arguments; console.log(action) };
FOR $ref IN $action.params {
LET $resource_id = (SELECT VALUE id FROM resources WHERE ref = $ref)[0];
CREATE papers CONTENT { resource: $resource_id, user: $paper.user };
};
};
IF $action.action = 'user_active' {};
IF $action.action = 'user_unactive' {};
IF $action.action = 'send_message' {};
};
RETURN $paper;
};
DEFINE FUNCTION fn::on_cron($script: string, $users: array<record<users>>) {
LET $script = (SELECT VALUE code FROM scripts WHERE name = $script)[0];
FOR $user IN $users {
LET $paper = (SELECT * FROM papers WHERE user = $user ORDER BY created DESC LIMIT 1);
LET $user = fn::run_script($script, $paper);
CREATE scores CONTENT { score: $user.score, user: $paper.user };
fn::actions($paper, $user);
};
function($script) { const [script] = arguments; console.log(script) };
function($users) { const [users] = arguments; console.log(users) };
};
DEFINE FUNCTION fn::on_push($paper: object) {
LET $script = (SELECT VALUE code FROM scripts WHERE name = 'push')[0];
LET $user = fn::run_script($script, $paper);
CREATE scores CONTENT { score: $user.score, user: $paper.user };
RETURN fn::actions($paper, $user);
};
DEFINE FUNCTION fn::run_script($script: string, $paper: option<object>) {
LET $score = (SELECT * FROM scores WHERE user = $paper.user ORDER BY created DESC LIMIT 1).score;
RETURN function($script, $paper, $score[0]) {
    const [script, paper, score] = arguments;

    const classUser = `class User {
      id;
      score;
      paper;
      actions = [];

      constructor(paper = {}, score = {}) {
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

-- ------------------------------
-- TABLE: answers
-- ------------------------------

DEFINE TABLE answers SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD answer ON answers TYPE string;
DEFINE FIELD question ON answers TYPE record<questions>;

DEFINE EVENT answers_log ON answers WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TABLE: papers
-- ------------------------------

DEFINE TABLE papers SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD answers ON papers TYPE option<array<record>> DEFAULT [];
DEFINE FIELD answers[*] ON papers TYPE record<answers>;
DEFINE FIELD completed ON papers TYPE bool DEFAULT false;
DEFINE FIELD created ON papers TYPE datetime DEFAULT time::now();
DEFINE FIELD resource ON papers TYPE record<resources>;
DEFINE FIELD user ON papers TYPE record<users>;

DEFINE EVENT papers_log ON papers WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };
DEFINE EVENT u_update_paper ON papers WHEN $event = 'UPDATE' THEN {
LET $user = $auth.id;
IF $user != NONE {
IF $value.completed != $before.completed OR $value.resource != $before.resource OR $value.user != $before.user {
CREATE logs SET index = $before.id, event = 'ERROR: update not allowed', time = time::now();
THROW 'Changes not allowed';
};
fn::on_push($value);
};
IF $value.completed = false { LET $value = fn::on_push($value); };
};

-- ------------------------------
-- TABLE: scores
-- ------------------------------

DEFINE TABLE scores SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD created ON scores TYPE datetime DEFAULT time::now();
DEFINE FIELD score ON scores FLEXIBLE TYPE object DEFAULT {  };
DEFINE FIELD user ON scores TYPE record<users>;

DEFINE EVENT scores_log ON scores WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: answers
-- ------------------------------


-- ------------------------------
-- TABLE DATA: papers
-- ------------------------------


-- ------------------------------
-- TABLE DATA: scores
-- ------------------------------


-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

