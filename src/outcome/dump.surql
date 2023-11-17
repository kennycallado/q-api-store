-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- USERS
-- ------------------------------

DEFINE USER viewer ON DATABASE PASSHASH '$argon2id$v=19$m=19456,t=2,p=1$MVdBN0YYucRfLeZNeh48lw$XN4ZQyJD/zXlWCjRled2toFRv89y+MW2PQ9lE9TmtLw' ROLES VIEWER;

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
DEFINE FIELD resource ON papers TYPE record<resources>;
DEFINE FIELD user ON papers TYPE record<users>;

DEFINE EVENT p_create_paper ON papers WHEN $event = 'CREATE' THEN { RELATE $project -> create_paper -> $value; };
DEFINE EVENT papers_log ON papers WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };
DEFINE EVENT u_update_paper ON papers WHEN $event = 'UPDATE' THEN {
LET $user = $auth.id;
IF $user != NONE {
IF $value.completed != $before.completed OR $value.resource != $before.resource OR $value.user != $before.user { THROW 'Update completed is not allowed'; };
fn::on_push($value);
};
fn::on_push($value);
};

-- ------------------------------
-- TABLE: records
-- ------------------------------

DEFINE TABLE records SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD created ON records TYPE datetime DEFAULT time::now();
DEFINE FIELD record ON records FLEXIBLE TYPE object;
DEFINE FIELD user ON records TYPE record<users>;

DEFINE EVENT p_generate_record ON records WHEN $event = 'CREATE' THEN { RELATE $project -> generate_record -> $value; };
DEFINE EVENT records_log ON records WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

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

RELATE projects:x85w529lxx2a3bgfsz11 -> create_paper:6oupzjytgtzns3pm3bhn -> papers:1 CONTENT { __: true, id: create_paper:6oupzjytgtzns3pm3bhn, in: projects:x85w529lxx2a3bgfsz11, out: papers:1 };

-- ------------------------------
-- TABLE DATA: logs
-- ------------------------------

UPDATE logs:5jr808pgl4fmwzou24ca CONTENT { event: 'CREATE', id: logs:5jr808pgl4fmwzou24ca, index: papers:1, time: '2023-11-17T08:50:02.658445394Z' };
UPDATE logs:c4ivia3chpdafumrtajt CONTENT { event: 'CREATE', id: logs:c4ivia3chpdafumrtajt, index: scripts:1, time: '2023-11-17T08:50:02.717022800Z' };
UPDATE logs:emiimve2uqlh1lveeah7 CONTENT { event: 'CREATE', id: logs:emiimve2uqlh1lveeah7, index: answers:1, time: '2023-11-17T08:50:02.615722743Z' };
UPDATE logs:jhr3mmg38pfpn7nb28nl CONTENT { event: 'CREATE', id: logs:jhr3mmg38pfpn7nb28nl, index: answers:2, time: '2023-11-17T08:50:02.615952293Z' };

-- ------------------------------
-- TABLE DATA: papers
-- ------------------------------

UPDATE papers:1 CONTENT { answers: [], completed: false, id: papers:1, resource: resources:1, user: users:1 };

-- ------------------------------
-- TABLE DATA: records
-- ------------------------------


-- ------------------------------
-- TABLE DATA: scripts
-- ------------------------------

UPDATE scripts:1 CONTENT { code: "console.log('hello form function')", id: scripts:1, name: 'push' };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

