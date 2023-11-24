-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- USERS
-- ------------------------------

DEFINE USER viewer ON DATABASE PASSHASH '$argon2id$v=19$m=19456,t=2,p=1$gH7lZzRCSx85iu5Vf6UXtA$Iy//osSuS3O+5eXHqf+/iyeU3oQQ6wHpXE2XNGuNW/g' ROLES VIEWER;

-- ------------------------------
-- PARAMS
-- ------------------------------

DEFINE PARAM $project VALUE projects:x85w529lxx2a3bgfsz11;

-- ------------------------------
-- TABLE: answers
-- ------------------------------

DEFINE TABLE answers SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD answer ON answers TYPE string;
DEFINE FIELD question ON answers TYPE record<questions>;

DEFINE EVENT answers_log ON answers WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };
DEFINE EVENT u_create_answer ON answers WHEN $event = 'CREATE' THEN {
LET $user = $auth.id;
IF $user != NONE { RELATE $user -> create_answer -> $value; };
};

-- ------------------------------
-- TABLE: create_paper
-- ------------------------------

DEFINE TABLE create_paper SCHEMALESS PERMISSIONS NONE;

-- ------------------------------
-- TABLE: logs
-- ------------------------------

DEFINE TABLE logs SCHEMALESS PERMISSIONS NONE;

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

DEFINE EVENT p_create_paper ON papers WHEN $event = 'CREATE' THEN { RELATE $project -> create_paper -> $value; };
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
IF $value.completed = false { LET $blah = fn::on_push($value); };
};

-- ------------------------------
-- TABLE: scores
-- ------------------------------

DEFINE TABLE scores SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD created ON scores TYPE datetime DEFAULT time::now();
DEFINE FIELD score ON scores FLEXIBLE TYPE object DEFAULT {  };
DEFINE FIELD user ON scores TYPE record<users>;

DEFINE EVENT p_generate_score ON scores WHEN $event = 'CREATE' THEN { RELATE $project -> generate_score -> $value; };
DEFINE EVENT scores_log ON scores WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TABLE: scripts
-- ------------------------------

DEFINE TABLE scripts SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD code ON scripts TYPE string;
DEFINE FIELD name ON scripts TYPE string;

DEFINE INDEX scripts_name ON scripts FIELDS name;

DEFINE EVENT scripts_log ON scripts WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: answers
-- ------------------------------

UPDATE answers:1 CONTENT { answer: '1', id: answers:1, question: questions:1 };
UPDATE answers:2 CONTENT { answer: '10', id: answers:2, question: questions:2 };

-- ------------------------------
-- TABLE DATA: create_paper
-- ------------------------------

RELATE projects:x85w529lxx2a3bgfsz11 -> create_paper:w4pczglmvp0kp9gnlgv6 -> papers:1 CONTENT { __: true, id: create_paper:w4pczglmvp0kp9gnlgv6, in: projects:x85w529lxx2a3bgfsz11, out: papers:1 };

-- ------------------------------
-- TABLE DATA: logs
-- ------------------------------

UPDATE logs:0areu7z8jywlj7x51d7u CONTENT { event: 'CREATE', id: logs:0areu7z8jywlj7x51d7u, index: papers:1, time: '2023-11-24T11:13:34.610906747Z' };
UPDATE logs:4k9arwo634h83pww9m41 CONTENT { event: 'CREATE', id: logs:4k9arwo634h83pww9m41, index: scripts:1, time: '2023-11-24T11:13:34.674408517Z' };
UPDATE logs:5ym6s1wzkag38e8fb14s CONTENT { event: 'CREATE', id: logs:5ym6s1wzkag38e8fb14s, index: answers:2, time: '2023-11-24T11:13:34.569554816Z' };
UPDATE logs:emrqjft4monaye8mg4uj CONTENT { event: 'UPDATE', id: logs:emrqjft4monaye8mg4uj, index: scripts:1, time: '2023-11-24T11:13:34.674948919Z' };
UPDATE logs:ionwxxo9645ss7js4uqt CONTENT { event: 'CREATE', id: logs:ionwxxo9645ss7js4uqt, index: answers:1, time: '2023-11-24T11:13:34.568798157Z' };

-- ------------------------------
-- TABLE DATA: papers
-- ------------------------------

UPDATE papers:1 CONTENT { answers: [], completed: false, created: '2023-11-24T11:13:34.610586433Z', id: papers:1, resource: resources:1, user: users:1 };

-- ------------------------------
-- TABLE DATA: scores
-- ------------------------------


-- ------------------------------
-- TABLE DATA: scripts
-- ------------------------------

UPDATE scripts:1 CONTENT { code: '
switch(user.score.step) {
  case 1:
    console.log("Reached step 1")
    break;

  case undefined:
    user.actions.push({ action: "add_resource", params: ["form-1"] });
    console.log("Resource added asynchronously");

    user.score = { step: 1 , mood: 0 , state: "ignition" };
    break;

  default:
    console.log("Reached default case");
    break;
}', id: scripts:1, name: 'push' };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

