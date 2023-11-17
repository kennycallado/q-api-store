-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- USERS
-- ------------------------------

DEFINE USER viewer ON DATABASE PASSHASH '$argon2id$v=19$m=19456,t=2,p=1$WnrpVjQtXris3oRt0m/4JQ$T5WxlMEELN8KtLXw34qZOS109jvTU+W+xF+0bZB9Eto' ROLES VIEWER;

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

RELATE projects:x85w529lxx2a3bgfsz11 -> create_locale:54itb1q5tx4w9exghzbz -> locales:zvj8gybxb7wn7igwxjf6 CONTENT { __: true, id: create_locale:54itb1q5tx4w9exghzbz, in: projects:x85w529lxx2a3bgfsz11, out: locales:zvj8gybxb7wn7igwxjf6 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_locale:gz74tdjz6g6s5vqp95ut -> locales:iweuk7jnv0wyiqhw8nfy CONTENT { __: true, id: create_locale:gz74tdjz6g6s5vqp95ut, in: projects:x85w529lxx2a3bgfsz11, out: locales:iweuk7jnv0wyiqhw8nfy };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_locale:wgykj0syovxm5grug49y -> locales:2gjyjqtwbqsqve2f26r9 CONTENT { __: true, id: create_locale:wgykj0syovxm5grug49y, in: projects:x85w529lxx2a3bgfsz11, out: locales:2gjyjqtwbqsqve2f26r9 };

-- ------------------------------
-- TABLE DATA: create_media
-- ------------------------------

RELATE projects:x85w529lxx2a3bgfsz11 -> create_media:w2085s1692ai1icmw7sa -> media:1 CONTENT { __: true, id: create_media:w2085s1692ai1icmw7sa, in: projects:x85w529lxx2a3bgfsz11, out: media:1 };

-- ------------------------------
-- TABLE DATA: create_question
-- ------------------------------

RELATE projects:x85w529lxx2a3bgfsz11 -> create_question:35ygc84l4f9jhpiiiu87 -> questions:1 CONTENT { __: true, id: create_question:35ygc84l4f9jhpiiiu87, in: projects:x85w529lxx2a3bgfsz11, out: questions:1 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_question:77vb6f4tomj3ydjlvzyv -> questions:5 CONTENT { __: true, id: create_question:77vb6f4tomj3ydjlvzyv, in: projects:x85w529lxx2a3bgfsz11, out: questions:5 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_question:iqqdm94vl9jl0tyzy5mz -> questions:3 CONTENT { __: true, id: create_question:iqqdm94vl9jl0tyzy5mz, in: projects:x85w529lxx2a3bgfsz11, out: questions:3 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_question:m99e6y3th2um5d3b7ror -> questions:2 CONTENT { __: true, id: create_question:m99e6y3th2um5d3b7ror, in: projects:x85w529lxx2a3bgfsz11, out: questions:2 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_question:x372f21t3kt10eq0l6wh -> questions:4 CONTENT { __: true, id: create_question:x372f21t3kt10eq0l6wh, in: projects:x85w529lxx2a3bgfsz11, out: questions:4 };

-- ------------------------------
-- TABLE DATA: create_resource
-- ------------------------------

RELATE projects:x85w529lxx2a3bgfsz11 -> create_resource:1wfhcequmfdfj668em38 -> resources:1 CONTENT { __: true, id: create_resource:1wfhcequmfdfj668em38, in: projects:x85w529lxx2a3bgfsz11, out: resources:1 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_resource:5abf9xce4bxkbf4f9jaz -> resources:3 CONTENT { __: true, id: create_resource:5abf9xce4bxkbf4f9jaz, in: projects:x85w529lxx2a3bgfsz11, out: resources:3 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_resource:md8m1h5at13lm8cxtgk5 -> resources:2 CONTENT { __: true, id: create_resource:md8m1h5at13lm8cxtgk5, in: projects:x85w529lxx2a3bgfsz11, out: resources:2 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_resource:p5eq85db062qd8znlyua -> resources:4 CONTENT { __: true, id: create_resource:p5eq85db062qd8znlyua, in: projects:x85w529lxx2a3bgfsz11, out: resources:4 };

-- ------------------------------
-- TABLE DATA: create_slide
-- ------------------------------

RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:56c0ykov3r4n3bi33gld -> slides:6 CONTENT { __: true, id: create_slide:56c0ykov3r4n3bi33gld, in: projects:x85w529lxx2a3bgfsz11, out: slides:6 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:68oxp0mcjnkjlrivdao7 -> slides:2 CONTENT { __: true, id: create_slide:68oxp0mcjnkjlrivdao7, in: projects:x85w529lxx2a3bgfsz11, out: slides:2 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:9p2tkvjdcmst3ulxoy3j -> slides:8 CONTENT { __: true, id: create_slide:9p2tkvjdcmst3ulxoy3j, in: projects:x85w529lxx2a3bgfsz11, out: slides:8 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:icz51trub069ydu9a8uz -> slides:7 CONTENT { __: true, id: create_slide:icz51trub069ydu9a8uz, in: projects:x85w529lxx2a3bgfsz11, out: slides:7 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:l345ays8aaegwvbhp9gx -> slides:3 CONTENT { __: true, id: create_slide:l345ays8aaegwvbhp9gx, in: projects:x85w529lxx2a3bgfsz11, out: slides:3 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:om93czjp7879fi5bg7hq -> slides:4 CONTENT { __: true, id: create_slide:om93czjp7879fi5bg7hq, in: projects:x85w529lxx2a3bgfsz11, out: slides:4 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:wjlj3quzpnzddwnn0hvz -> slides:1 CONTENT { __: true, id: create_slide:wjlj3quzpnzddwnn0hvz, in: projects:x85w529lxx2a3bgfsz11, out: slides:1 };
RELATE projects:x85w529lxx2a3bgfsz11 -> create_slide:zab7609hfjr8do7k0kjm -> slides:5 CONTENT { __: true, id: create_slide:zab7609hfjr8do7k0kjm, in: projects:x85w529lxx2a3bgfsz11, out: slides:5 };

-- ------------------------------
-- TABLE DATA: locales
-- ------------------------------

UPDATE locales:2gjyjqtwbqsqve2f26r9 CONTENT { id: locales:2gjyjqtwbqsqve2f26r9, locale: 'es' };
UPDATE locales:iweuk7jnv0wyiqhw8nfy CONTENT { id: locales:iweuk7jnv0wyiqhw8nfy, locale: 'en' };
UPDATE locales:zvj8gybxb7wn7igwxjf6 CONTENT { id: locales:zvj8gybxb7wn7igwxjf6, locale: 'vl' };

-- ------------------------------
-- TABLE DATA: logs
-- ------------------------------

UPDATE logs:0smj11068e2aq3yly1mt CONTENT { event: 'CREATE', id: logs:0smj11068e2aq3yly1mt, index: slides:2, time: '2023-11-17T08:50:02.480245268Z' };
UPDATE logs:2cfvmuwyuit2rap8plvq CONTENT { event: 'CREATE', id: logs:2cfvmuwyuit2rap8plvq, index: questions:2, time: '2023-11-17T08:50:02.437174896Z' };
UPDATE logs:2v96489u86n6ec919bx9 CONTENT { event: 'CREATE', id: logs:2v96489u86n6ec919bx9, index: media:1, time: '2023-11-17T08:50:02.394441225Z' };
UPDATE logs:3udt1j88jum6i7vzmd49 CONTENT { event: 'CREATE', id: logs:3udt1j88jum6i7vzmd49, index: questions:3, time: '2023-11-17T08:50:02.437555991Z' };
UPDATE logs:6s051baq4dpwypesq258 CONTENT { event: 'CREATE', id: logs:6s051baq4dpwypesq258, index: questions:4, time: '2023-11-17T08:50:02.437920411Z' };
UPDATE logs:a1io0w5gh6km1ha98797 CONTENT { event: 'CREATE', id: logs:a1io0w5gh6km1ha98797, index: slides:4, time: '2023-11-17T08:50:02.481195958Z' };
UPDATE logs:bf914ux5itq2x19vm3u7 CONTENT { event: 'CREATE', id: logs:bf914ux5itq2x19vm3u7, index: resources:1, time: '2023-11-17T08:50:02.522787133Z' };
UPDATE logs:bmf8llosyfcepkptq7na CONTENT { event: 'CREATE', id: logs:bmf8llosyfcepkptq7na, index: slides:6, time: '2023-11-17T08:50:02.481720049Z' };
UPDATE logs:c2atb9rai2pp1haldmxy CONTENT { event: 'CREATE', id: logs:c2atb9rai2pp1haldmxy, index: slides:3, time: '2023-11-17T08:50:02.480909001Z' };
UPDATE logs:cbvggh0hf81l6784eppw CONTENT { event: 'CREATE', id: logs:cbvggh0hf81l6784eppw, index: locales:zvj8gybxb7wn7igwxjf6, time: '2023-11-17T08:50:02.355468493Z' };
UPDATE logs:dkcc2pctsm7ln6b3gtxk CONTENT { event: 'CREATE', id: logs:dkcc2pctsm7ln6b3gtxk, index: locales:2gjyjqtwbqsqve2f26r9, time: '2023-11-17T08:50:02.355775186Z' };
UPDATE logs:jlod4vwg315o795oxoyk CONTENT { event: 'CREATE', id: logs:jlod4vwg315o795oxoyk, index: locales:iweuk7jnv0wyiqhw8nfy, time: '2023-11-17T08:50:02.355894032Z' };
UPDATE logs:jr2p870z4vixsa37u9xa CONTENT { event: 'CREATE', id: logs:jr2p870z4vixsa37u9xa, index: questions:1, time: '2023-11-17T08:50:02.436721726Z' };
UPDATE logs:o4w7bg9t83w7t9e6wi7o CONTENT { event: 'CREATE', id: logs:o4w7bg9t83w7t9e6wi7o, index: questions:5, time: '2023-11-17T08:50:02.438303274Z' };
UPDATE logs:omegaga3r3e9gi7i7tbf CONTENT { event: 'CREATE', id: logs:omegaga3r3e9gi7i7tbf, index: slides:7, time: '2023-11-17T08:50:02.481938998Z' };
UPDATE logs:omftc8njs1chkmqurrz8 CONTENT { event: 'CREATE', id: logs:omftc8njs1chkmqurrz8, index: resources:3, time: '2023-11-17T08:50:02.523455980Z' };
UPDATE logs:oxs8ye2xkq3iwznu6o1a CONTENT { event: 'CREATE', id: logs:oxs8ye2xkq3iwznu6o1a, index: slides:8, time: '2023-11-17T08:50:02.482162278Z' };
UPDATE logs:q3xbkhn0tmvpdouv7wpb CONTENT { event: 'CREATE', id: logs:q3xbkhn0tmvpdouv7wpb, index: resources:2, time: '2023-11-17T08:50:02.523153617Z' };
UPDATE logs:rdwvcusdszmu63slqpgz CONTENT { event: 'CREATE', id: logs:rdwvcusdszmu63slqpgz, index: slides:1, time: '2023-11-17T08:50:02.479309871Z' };
UPDATE logs:vk7fin3djx4q0aku7ryn CONTENT { event: 'CREATE', id: logs:vk7fin3djx4q0aku7ryn, index: resources:4, time: '2023-11-17T08:50:02.523743295Z' };
UPDATE logs:zt75emdwi41mbe9abdxd CONTENT { event: 'CREATE', id: logs:zt75emdwi41mbe9abdxd, index: slides:5, time: '2023-11-17T08:50:02.481427767Z' };

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

