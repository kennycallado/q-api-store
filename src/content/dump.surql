-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- USERS
-- ------------------------------

DEFINE USER viewer ON DATABASE PASSHASH '$argon2id$v=19$m=19456,t=2,p=1$gFFGTwTJF4ikg6b0o+SRGQ$q7IPNapb1EC6Gt6pZcNiSnVOoke1oP2H/f6OvyLAjKQ' ROLES VIEWER;

-- ------------------------------
-- PARAMS
-- ------------------------------

DEFINE PARAM $project VALUE projects:x85w529lxx2a3bgfsz11;

-- ------------------------------
-- TABLE: create_locale
-- ------------------------------

DEFINE TABLE create_locale SCHEMALESS PERMISSIONS NONE;

-- ------------------------------
-- TABLE: create_media
-- ------------------------------

DEFINE TABLE create_media SCHEMALESS PERMISSIONS NONE;

-- ------------------------------
-- TABLE: create_question
-- ------------------------------

DEFINE TABLE create_question SCHEMALESS PERMISSIONS NONE;

-- ------------------------------
-- TABLE: create_resource
-- ------------------------------

DEFINE TABLE create_resource SCHEMALESS PERMISSIONS NONE;

-- ------------------------------
-- TABLE: create_slide
-- ------------------------------

DEFINE TABLE create_slide SCHEMALESS PERMISSIONS NONE;

-- ------------------------------
-- TABLE: locales
-- ------------------------------

DEFINE TABLE locales SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD locale ON locales TYPE string;

DEFINE EVENT locales_log ON locales WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };
DEFINE EVENT p_create_locale ON locales WHEN $event = 'CREATE' THEN { RELATE $project -> create_locale -> $value; };

-- ------------------------------
-- TABLE: logs
-- ------------------------------

DEFINE TABLE logs SCHEMALESS PERMISSIONS NONE;

-- ------------------------------
-- TABLE: media
-- ------------------------------

DEFINE TABLE media SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD alt ON media TYPE option<string>;
DEFINE FIELD type ON media TYPE string ASSERT $value INSIDE ['image', 'video'];
DEFINE FIELD url ON media TYPE string ASSERT string::is::url($value);

DEFINE EVENT media_log ON media WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };
DEFINE EVENT p_create_media ON media WHEN $event = 'CREATE' THEN { RELATE $project -> create_media -> $value; };

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

DEFINE EVENT p_create_question ON questions WHEN $event = 'CREATE' THEN { RELATE $project -> create_question -> $value; };
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

DEFINE EVENT p_create_resource ON resources WHEN $event = 'CREATE' THEN { RELATE $project -> create_resource -> $value; };
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

DEFINE EVENT p_create_slide ON slides WHEN $event = 'CREATE' THEN { RELATE $project -> create_slide -> $value; };
DEFINE EVENT slides_log ON slides WHEN $event = 'CREATE' OR $event = 'UPDATE' OR $event = 'DELETE' THEN { IF $event = 'DELETE' { CREATE logs SET index = $before.id, event = $event, time = time::now(); } ELSE { CREATE logs SET index = $value.id, event = $event, time = time::now(); }; };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: create_locale
-- ------------------------------

RELATE projects:x85w529lxx2a3bgfsz11 -> create_locale:0r8h8xj0q81pgzyg7ol7 -> locales:jy0q6zzcidmqth3q6dls CONTENT { __: true, id: create_locale:0r8h8xj0q81pgzyg7ol7, in: projects:x85w529lxx2a3bgfsz11, out: locales:jy0q6zzcidmqth3q6dls };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_locale:gof8bzpihhr0s7drjq1x -> locales:4ep3tjt7hrenbhgzwj9b CONTENT { __: true, id: create_locale:gof8bzpihhr0s7drjq1x, in: projects:x85w529lxx2a3bgfsz11, out: locales:4ep3tjt7hrenbhgzwj9b };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_locale:iw6slwfkrnyvyk236n1k -> locales:qrygh2oo2w10fikxofjc CONTENT { __: true, id: create_locale:iw6slwfkrnyvyk236n1k, in: projects:x85w529lxx2a3bgfsz11, out: locales:qrygh2oo2w10fikxofjc };

-- ------------------------------
-- TABLE DATA: create_media
-- ------------------------------

RELATE projects:x85w529lxx2a3bgfsz11 -> create_media:da4t9o4qg3x8epsij7og -> media:1 CONTENT { __: true, id: create_media:da4t9o4qg3x8epsij7og, in: projects:x85w529lxx2a3bgfsz11, out: media:1 };

-- ------------------------------
-- TABLE DATA: create_question
-- ------------------------------

RELATE projects:x85w529lxx2a3bgfsz11 -> create_question:2hwgmwzwhn2v1obf8f0v -> questions:5 CONTENT { __: true, id: create_question:2hwgmwzwhn2v1obf8f0v, in: projects:x85w529lxx2a3bgfsz11, out: questions:5 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_question:4ayjogoob5nl4jqbkhcc -> questions:1 CONTENT { __: true, id: create_question:4ayjogoob5nl4jqbkhcc, in: projects:x85w529lxx2a3bgfsz11, out: questions:1 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_question:skyv5o5wpoioafemcc1t -> questions:3 CONTENT { __: true, id: create_question:skyv5o5wpoioafemcc1t, in: projects:x85w529lxx2a3bgfsz11, out: questions:3 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_question:u4elqj6a6b1os390xg7z -> questions:4 CONTENT { __: true, id: create_question:u4elqj6a6b1os390xg7z, in: projects:x85w529lxx2a3bgfsz11, out: questions:4 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_question:urozc3opnte51a30n7k1 -> questions:2 CONTENT { __: true, id: create_question:urozc3opnte51a30n7k1, in: projects:x85w529lxx2a3bgfsz11, out: questions:2 };

-- ------------------------------
-- TABLE DATA: create_resource
-- ------------------------------

RELATE projects:x85w529lxx2a3bgfsz11 -> create_resource:39npvmldlyl9ndg98opu -> resources:2 CONTENT { __: true, id: create_resource:39npvmldlyl9ndg98opu, in: projects:x85w529lxx2a3bgfsz11, out: resources:2 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_resource:4nulz8k57b92r44wzfxr -> resources:1 CONTENT { __: true, id: create_resource:4nulz8k57b92r44wzfxr, in: projects:x85w529lxx2a3bgfsz11, out: resources:1 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_resource:qvg3n7xr9e3butee4knf -> resources:3 CONTENT { __: true, id: create_resource:qvg3n7xr9e3butee4knf, in: projects:x85w529lxx2a3bgfsz11, out: resources:3 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_resource:r6gtcj1qkwt851ok1qcb -> resources:4 CONTENT { __: true, id: create_resource:r6gtcj1qkwt851ok1qcb, in: projects:x85w529lxx2a3bgfsz11, out: resources:4 };

-- ------------------------------
-- TABLE DATA: create_slide
-- ------------------------------

RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:2f3g81tvpxas9eflgx8b -> slides:1 CONTENT { __: true, id: create_slide:2f3g81tvpxas9eflgx8b, in: projects:x85w529lxx2a3bgfsz11, out: slides:1 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:8cmtrcagrs0a65xsgux2 -> slides:4 CONTENT { __: true, id: create_slide:8cmtrcagrs0a65xsgux2, in: projects:x85w529lxx2a3bgfsz11, out: slides:4 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:97j3f38e61dva4ldnge0 -> slides:7 CONTENT { __: true, id: create_slide:97j3f38e61dva4ldnge0, in: projects:x85w529lxx2a3bgfsz11, out: slides:7 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:9avksl59sr0jl0stx9rb -> slides:8 CONTENT { __: true, id: create_slide:9avksl59sr0jl0stx9rb, in: projects:x85w529lxx2a3bgfsz11, out: slides:8 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:aevrpiekpl1ptuuxl0lx -> slides:5 CONTENT { __: true, id: create_slide:aevrpiekpl1ptuuxl0lx, in: projects:x85w529lxx2a3bgfsz11, out: slides:5 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:h6dwq815zxn6ry4sy7tq -> slides:2 CONTENT { __: true, id: create_slide:h6dwq815zxn6ry4sy7tq, in: projects:x85w529lxx2a3bgfsz11, out: slides:2 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:i9l1se6d8gwgc0gc0y7k -> slides:6 CONTENT { __: true, id: create_slide:i9l1se6d8gwgc0gc0y7k, in: projects:x85w529lxx2a3bgfsz11, out: slides:6 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:wn1t650isyqa34wk42e9 -> slides:3 CONTENT { __: true, id: create_slide:wn1t650isyqa34wk42e9, in: projects:x85w529lxx2a3bgfsz11, out: slides:3 };

-- ------------------------------
-- TABLE DATA: locales
-- ------------------------------

UPDATE locales:4ep3tjt7hrenbhgzwj9b CONTENT { id: locales:4ep3tjt7hrenbhgzwj9b, locale: 'en' };
UPDATE locales:jy0q6zzcidmqth3q6dls CONTENT { id: locales:jy0q6zzcidmqth3q6dls, locale: 'es' };
UPDATE locales:qrygh2oo2w10fikxofjc CONTENT { id: locales:qrygh2oo2w10fikxofjc, locale: 'vl' };

-- ------------------------------
-- TABLE DATA: logs
-- ------------------------------

UPDATE logs:32qaurvx1wiwzkn22b6v CONTENT { event: 'CREATE', id: logs:32qaurvx1wiwzkn22b6v, index: slides:8, time: '2023-11-24T11:13:34.430813779Z' };
UPDATE logs:4q78udjyjs21puj7lxli CONTENT { event: 'CREATE', id: logs:4q78udjyjs21puj7lxli, index: resources:1, time: '2023-11-24T11:13:34.472706171Z' };
UPDATE logs:79ksr3jbj0j1n62jr909 CONTENT { event: 'CREATE', id: logs:79ksr3jbj0j1n62jr909, index: questions:2, time: '2023-11-24T11:13:34.386949695Z' };
UPDATE logs:8iftfpih9u1h6z8naveu CONTENT { event: 'CREATE', id: logs:8iftfpih9u1h6z8naveu, index: media:1, time: '2023-11-24T11:13:34.343766963Z' };
UPDATE logs:9javvgwq2cup98ie9w6p CONTENT { event: 'CREATE', id: logs:9javvgwq2cup98ie9w6p, index: questions:5, time: '2023-11-24T11:13:34.389458743Z' };
UPDATE logs:avt7u972798q9j5b0w2q CONTENT { event: 'CREATE', id: logs:avt7u972798q9j5b0w2q, index: questions:1, time: '2023-11-24T11:13:34.386484956Z' };
UPDATE logs:bsliru0a4c2bwsuy5lwv CONTENT { event: 'CREATE', id: logs:bsliru0a4c2bwsuy5lwv, index: locales:qrygh2oo2w10fikxofjc, time: '2023-11-24T11:13:34.304041811Z' };
UPDATE logs:bu2pjozf8kl66eds6p42 CONTENT { event: 'CREATE', id: logs:bu2pjozf8kl66eds6p42, index: locales:4ep3tjt7hrenbhgzwj9b, time: '2023-11-24T11:13:34.304964838Z' };
UPDATE logs:d12yy5pe87t4kt6ko5rp CONTENT { event: 'CREATE', id: logs:d12yy5pe87t4kt6ko5rp, index: resources:4, time: '2023-11-24T11:13:34.473773307Z' };
UPDATE logs:dyexsmlnx9gjor5pt37o CONTENT { event: 'CREATE', id: logs:dyexsmlnx9gjor5pt37o, index: slides:2, time: '2023-11-24T11:13:34.429389607Z' };
UPDATE logs:forgeky1wczgf4ll7z2l CONTENT { event: 'CREATE', id: logs:forgeky1wczgf4ll7z2l, index: questions:4, time: '2023-11-24T11:13:34.388774941Z' };
UPDATE logs:g8vae67hh7ehrhrhl3m4 CONTENT { event: 'CREATE', id: logs:g8vae67hh7ehrhrhl3m4, index: locales:jy0q6zzcidmqth3q6dls, time: '2023-11-24T11:13:34.304591304Z' };
UPDATE logs:iz0lbenqo9v5rtpkhz6j CONTENT { event: 'CREATE', id: logs:iz0lbenqo9v5rtpkhz6j, index: questions:3, time: '2023-11-24T11:13:34.387815328Z' };
UPDATE logs:nko0wjrcw8cha06jfxqh CONTENT { event: 'CREATE', id: logs:nko0wjrcw8cha06jfxqh, index: slides:4, time: '2023-11-24T11:13:34.429901506Z' };
UPDATE logs:scidlpa918ix1pncq56h CONTENT { event: 'CREATE', id: logs:scidlpa918ix1pncq56h, index: slides:7, time: '2023-11-24T11:13:34.430595191Z' };
UPDATE logs:su9q3if4lt95mifrp1n3 CONTENT { event: 'CREATE', id: logs:su9q3if4lt95mifrp1n3, index: resources:2, time: '2023-11-24T11:13:34.473131994Z' };
UPDATE logs:tnwnt12alik11dumgn1i CONTENT { event: 'CREATE', id: logs:tnwnt12alik11dumgn1i, index: slides:3, time: '2023-11-24T11:13:34.429658306Z' };
UPDATE logs:x6woijahqlrxhzkq2wa5 CONTENT { event: 'CREATE', id: logs:x6woijahqlrxhzkq2wa5, index: slides:5, time: '2023-11-24T11:13:34.430144363Z' };
UPDATE logs:xbkl9zaomtos6k4dsmrq CONTENT { event: 'CREATE', id: logs:xbkl9zaomtos6k4dsmrq, index: resources:3, time: '2023-11-24T11:13:34.473469508Z' };
UPDATE logs:xxdutsxhsv5kjhzfu17q CONTENT { event: 'CREATE', id: logs:xxdutsxhsv5kjhzfu17q, index: slides:6, time: '2023-11-24T11:13:34.430383434Z' };
UPDATE logs:y0sovi78ei70fvs9m7vc CONTENT { event: 'CREATE', id: logs:y0sovi78ei70fvs9m7vc, index: slides:1, time: '2023-11-24T11:13:34.429067660Z' };

-- ------------------------------
-- TABLE DATA: media
-- ------------------------------

UPDATE media:1 CONTENT { alt: 'Google logo', id: media:1, type: 'image', url: 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png' };

-- ------------------------------
-- TABLE DATA: questions
-- ------------------------------

UPDATE questions:1 CONTENT { id: questions:1, question: [{ content: '¿Con qué frecuencia te sientes capaz de superar con éxito los desafíos?', locale: 'es' }, { content: 'How often do you feel capable of successfully overcoming challenges?', locale: 'en' }], range: { max: 10, min: 0, value: -1 }, type: 'range' };
UPDATE questions:2 CONTENT { id: questions:2, question: [{ content: '¿Con qué frecuencia sientes que tienes el poder para hacer cambios positivos en tu vida?', locale: 'es' }, { content: 'How often do you feel you have the power to make positive changes in your life?', locale: 'en' }], range: { max: 10, min: 0, value: -1 }, type: 'range' };
UPDATE questions:3 CONTENT { id: questions:3, question: [{ content: '¿Con qué frecuencia sientes que puedes tomar decisiones sabias?', locale: 'es' }, { content: 'How often do you feel you are able to make wise decisions?', locale: 'en' }], range: { max: 10, min: 0, value: -1 }, type: 'range' };
UPDATE questions:4 CONTENT { id: questions:4, question: [{ content: '¿Con qué frecuencia te sientes seguro de tu capacidad para alcanzar tus metas?', locale: 'es' }, { content: 'How often do you feel confident in your ability to achieve your goals?', locale: 'en' }], range: { max: 10, min: 0, value: -1 }, type: 'range' };
UPDATE questions:5 CONTENT { id: questions:5, question: [{ content: '¿Con qué frecuencia sientes que tienes la fuerza para mantener la resiliencia en situaciones difíciles?', locale: 'es' }, { content: 'How often do you feel you have the strength to stay resilient in difficult situations?', locale: 'en' }], range: { max: 10, min: 0, value: -1 }, type: 'range' };

-- ------------------------------
-- TABLE DATA: resources
-- ------------------------------

UPDATE resources:1 CONTENT { description: 'This is a module', id: resources:1, module: [slides:1, slides:2, slides:5, slides:7, slides:8], ref: 'module-1', title: 'Module 1', type: 'module' };
UPDATE resources:2 CONTENT { description: 'This is a form', form: [questions:1, questions:2, questions:3, questions:4, questions:5], id: resources:2, ref: 'form-1', title: 'Form 1', type: 'form' };
UPDATE resources:3 CONTENT { description: 'This is a slide two', id: resources:3, ref: 'slides-2', slides: [slides:1, slides:4, slides:5, slides:6], title: 'Slides 2', type: 'slides' };
UPDATE resources:4 CONTENT { description: 'This is a slide one', id: resources:4, ref: 'slides-1', slides: [slides:5, slides:3, slides:7, slides:4], title: 'Slides 1', type: 'slides' };

-- ------------------------------
-- TABLE DATA: slides
-- ------------------------------

UPDATE slides:1 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', id: slides:1, title: 'Slide 3', type: 'content' };
UPDATE slides:2 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', id: slides:2, title: 'Slide 1', type: 'content' };
UPDATE slides:3 CONTENT { id: slides:3, question: questions:1, title: 'Slide 8', type: 'input' };
UPDATE slides:4 CONTENT { id: slides:4, question: questions:2, title: 'Slide 7', type: 'input' };
UPDATE slides:5 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', id: slides:5, title: 'Slide 4', type: 'content' };
UPDATE slides:6 CONTENT { id: slides:6, question: questions:3, title: 'Slide 6', type: 'input' };
UPDATE slides:7 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', id: slides:7, title: 'Slide 5', type: 'content' };
UPDATE slides:8 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', id: slides:8, title: 'Slide 2', type: 'content' };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

