-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- USERS
-- ------------------------------

DEFINE USER viewer ON DATABASE PASSHASH '$argon2id$v=19$m=19456,t=2,p=1$Oj6sTVhxQOa3zp1DlsskIQ$/s2eUkrLNs8xqk95tV/pPLMVeUefm869ycEjIOUbqHY' ROLES VIEWER;

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
IF $value.completed != $before.completed OR $value.resource != $before.resource OR $value.user != $before.user { THROW 'Changes not allowed'; };
fn::on_push($value);
};
fn::on_push($value);
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

RELATE projects:x85w529lxx2a3bgfsz11 -> create_paper:ghevbdpumd40dxxc7a5a -> papers:1 CONTENT { __: true, id: create_paper:ghevbdpumd40dxxc7a5a, in: projects:x85w529lxx2a3bgfsz11, out: papers:1 };

-- ------------------------------
-- TABLE DATA: logs
-- ------------------------------

UPDATE logs:al6qadh05pgd7jgj2y6g CONTENT { event: 'CREATE', id: logs:al6qadh05pgd7jgj2y6g, index: answers:2, time: '2023-11-22T14:43:43.949488626Z' };
UPDATE logs:nwfp96ypyb25y5vicwzf CONTENT { event: 'CREATE', id: logs:nwfp96ypyb25y5vicwzf, index: answers:1, time: '2023-11-22T14:43:43.949305924Z' };
UPDATE logs:sg3jfehsp5xdx585ehgg CONTENT { event: 'CREATE', id: logs:sg3jfehsp5xdx585ehgg, index: scripts:1, time: '2023-11-22T14:43:44.047859408Z' };
UPDATE logs:utv1vnoy7h786knv1cj8 CONTENT { event: 'CREATE', id: logs:utv1vnoy7h786knv1cj8, index: papers:1, time: '2023-11-22T14:43:43.989674012Z' };

-- ------------------------------
-- TABLE DATA: papers
-- ------------------------------

UPDATE papers:1 CONTENT { answers: [], completed: false, created: '2023-11-22T14:43:43.989406362Z', id: papers:1, resource: resources:1, user: users:1 };

-- ------------------------------
-- TABLE DATA: scores
-- ------------------------------


-- ------------------------------
-- TABLE DATA: scripts
-- ------------------------------

UPDATE scripts:1 CONTENT { code: "console.log('hello form function')", id: scripts:1, name: 'push' };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

