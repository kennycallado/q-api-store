-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- TABLE: locales
-- ------------------------------

DEFINE TABLE locales SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD locale ON locales TYPE string ASSERT string::len($value) = 2;

DEFINE EVENT locales_log ON locales WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TABLE: media
-- ------------------------------

DEFINE TABLE media SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD alt ON media TYPE option<string>;
DEFINE FIELD type ON media TYPE string ASSERT $value INSIDE ['image', 'video'];
DEFINE FIELD url ON media TYPE string ASSERT string::is::url($value);

DEFINE EVENT media_log ON media WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TABLE: questions
-- ------------------------------

DEFINE TABLE questions SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD question ON questions TYPE array<object> ASSERT array::len($value) < 4 AND array::len($value) > 0;
DEFINE FIELD question[*] ON questions TYPE object;
DEFINE FIELD question[*].content ON questions TYPE string ASSERT $value != EMPTY AND string::len($value) < 250;
DEFINE FIELD question[*].locale ON questions TYPE string ASSERT $value INSIDE (SELECT VALUE locale FROM locales);
DEFINE FIELD range ON questions TYPE option<object> ASSERT $value = NONE OR type = 'range';
DEFINE FIELD range.max ON questions TYPE option<number> ASSERT $value = NONE OR range != NONE;
DEFINE FIELD range.min ON questions TYPE option<number> ASSERT $value = NONE OR range != NONE;
DEFINE FIELD range.value ON questions TYPE option<number> ASSERT $value = NONE OR range != NONE;
DEFINE FIELD type ON questions TYPE string ASSERT $value INSIDE ['range', 'input'];

DEFINE EVENT questions_log ON questions WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TABLE: resources
-- ------------------------------

DEFINE TABLE resources SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD description ON resources TYPE string;
DEFINE FIELD form ON resources TYPE option<array<record>> ASSERT $value = NONE OR type = 'form' AND array::len($value) > 0;
DEFINE FIELD form[*] ON resources TYPE record<questions>;
DEFINE FIELD module ON resources TYPE option<array<record>> ASSERT $value = NONE OR type = 'module' AND array::len($value) > 0;
DEFINE FIELD module[*] ON resources TYPE record<slides>;
DEFINE FIELD ref ON resources TYPE string VALUE string::slug($value) ASSERT $value != EMPTY;
DEFINE FIELD slides ON resources TYPE option<array<record>> ASSERT $value = NONE OR type = 'slides' AND array::len($value) > 0;
DEFINE FIELD slides[*] ON resources TYPE record<slides>;
DEFINE FIELD title ON resources TYPE string ASSERT $value != EMPTY;
DEFINE FIELD type ON resources TYPE string ASSERT $value INSIDE ['slides', 'module', 'form', 'external'];

DEFINE INDEX resources_ref_unique ON resources FIELDS ref UNIQUE;

DEFINE EVENT resources_log ON resources WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TABLE: slides
-- ------------------------------

DEFINE TABLE slides SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD content ON slides TYPE option<string>;
DEFINE FIELD media ON slides TYPE option<record<media>>;
DEFINE FIELD question ON slides TYPE option<record<questions>> ASSERT $value = NONE OR (type = 'input' AND questions = NONE);
DEFINE FIELD title ON slides TYPE string;
DEFINE FIELD type ON slides TYPE string ASSERT $value INSIDE ['content', 'input'];

DEFINE EVENT slides_log ON slides WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: locales
-- ------------------------------


-- ------------------------------
-- TABLE DATA: media
-- ------------------------------


-- ------------------------------
-- TABLE DATA: questions
-- ------------------------------


-- ------------------------------
-- TABLE DATA: resources
-- ------------------------------


-- ------------------------------
-- TABLE DATA: slides
-- ------------------------------


-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

