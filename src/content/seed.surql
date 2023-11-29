
-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: content/locales
-- ------------------------------

INSERT INTO locales [{locale: 'vl'}, {locale: 'es'}, {locale: 'en'}];

-- ------------------------------
-- TABLE DATA: content/media
-- ------------------------------

-- CREATE media CONTENT {
--   type: 'image',
--   url: 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
--   alt: 'Google logo',
-- }

UPDATE media:1 CONTENT { alt: 'Google logo', type: 'image', url: 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png' };

-- ------------------------------
-- TABLE DATA: content/questions
-- ------------------------------

-- INSERT INTO questions [
--   { type: 'range', range: { min: 0, max: 10, value: -1}, question: [
--       -- {locale: 'vl', content: ''},
--       {locale: 'es', content: '¿Con qué frecuencia te sientes seguro de tu capacidad para alcanzar tus metas?'},
--       {locale: 'en', content: 'How often do you feel confident in your ability to achieve your goals?'}
--     ]
--   }, {
--     type: 'range',
--     range: { min: 0, max: 10, value: -1},
--     question: [
--       -- {locale: 'vl', content: ''},
--       {locale: 'es', content: '¿Con qué frecuencia te sientes capaz de superar con éxito los desafíos?'},
--       {locale: 'en', content: 'How often do you feel capable of successfully overcoming challenges?'}
--     ]
--   }, {
--     type: 'range',
--     range: { min: 0, max: 10, value: -1},
--     question: [
--       -- {locale: 'vl', content: ''},
--       {locale: 'es', content: '¿Con qué frecuencia sientes que puedes tomar decisiones sabias?'},
--       {locale: 'en', content: 'How often do you feel you are able to make wise decisions?'}
--     ]
--   }, {
--     type: 'range',
--     range: { min: 0, max: 10, value: -1},
--     question: [
--       -- {locale: 'vl', content: ''},
--       {locale: 'es', content: '¿Con qué frecuencia sientes que tienes la fuerza para mantener la resiliencia en situaciones difíciles?'},
--       {locale: 'en', content: 'How often do you feel you have the strength to stay resilient in difficult situations?'}
--     ]
--   }, {
--     type: 'range',
--     range: { min: 0, max: 10, value: -1},
--     question: [
--       -- {locale: 'vl', content: ''},
--       {locale: 'es', content: '¿Con qué frecuencia sientes que tienes el poder para hacer cambios positivos en tu vida?'},
--       {locale: 'en', content: 'How often do you feel you have the power to make positive changes in your life?'}
--     ]
--   }
-- ];

UPDATE questions:1 CONTENT { question: [{ content: '¿Con qué frecuencia te sientes capaz de superar con éxito los desafíos?', locale: 'es' }, { content: 'How often do you feel capable of successfully overcoming challenges?', locale: 'en' }], range: { max: 10, min: 0, value: -1 }, type: 'range' };
UPDATE questions:2 CONTENT { question: [{ content: '¿Con qué frecuencia sientes que tienes el poder para hacer cambios positivos en tu vida?', locale: 'es' }, { content: 'How often do you feel you have the power to make positive changes in your life?', locale: 'en' }], range: { max: 10, min: 0, value: -1 }, type: 'range' };
UPDATE questions:3 CONTENT { question: [{ content: '¿Con qué frecuencia sientes que puedes tomar decisiones sabias?', locale: 'es' }, { content: 'How often do you feel you are able to make wise decisions?', locale: 'en' }], range: { max: 10, min: 0, value: -1 }, type: 'range' };
UPDATE questions:4 CONTENT { question: [{ content: '¿Con qué frecuencia te sientes seguro de tu capacidad para alcanzar tus metas?', locale: 'es' }, { content: 'How often do you feel confident in your ability to achieve your goals?', locale: 'en' }], range: { max: 10, min: 0, value: -1 }, type: 'range' };
UPDATE questions:5 CONTENT { question: [{ content: '¿Con qué frecuencia sientes que tienes la fuerza para mantener la resiliencia en situaciones difíciles?', locale: 'es' }, { content: 'How often do you feel you have the strength to stay resilient in difficult situations?', locale: 'en' }], range: { max: 10, min: 0, value: -1 }, type: 'range' };

-- ------------------------------
-- TABLE DATA: content/slides
-- ------------------------------

-- INSERT INTO slides [
--   {
--     title: 'Slide 1',
--     content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.',
--     type: 'content',
--   }, {
--     title: 'Slide 2',
--     content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.',
--     type: 'content',
--   }, {
--     title: 'Slide 3',
--     content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.',
--     type: 'content',
--   }, {
--     title: 'Slide 4',
--     content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.',
--     type: 'content',
--   }, {
--     title: 'Slide 5',
--     content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.',
--     type: 'content',
--   }, {
--     title: 'Slide 6',
--     type: 'input',
--     question: questions:1,
--   }, {
--     title: 'Slide 7',
--     type: 'input',
--     question: questions:2,
--   }, {
--     title: 'Slide 8',
--     type: 'input',
--     question: questions:3,
--   }
-- ];

UPDATE slides:1 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 3', type: 'content' };
UPDATE slides:2 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 1', type: 'content' };
UPDATE slides:3 CONTENT { question: questions:1, title: 'Slide 8', type: 'input' };
UPDATE slides:4 CONTENT { question: questions:2, title: 'Slide 7', type: 'input' };
UPDATE slides:5 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 4', type: 'content' };
UPDATE slides:6 CONTENT { question: questions:3, title: 'Slide 6', type: 'input' };
UPDATE slides:7 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 5', type: 'content' };
UPDATE slides:8 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 2', type: 'content' };

-- ------------------------------
-- TABLE DATA: content/resources
-- ------------------------------

-- INSERT INTO resources [
--   {
--     title: 'Form 1',
--     description: 'This is a form',
--     ref: 'form 1',
--     type: 'form',
--     form: [ 
--       questions:1,
--       questions:2,
--       questions:3,
--       questions:4,
--       questions:5
--     ]
--   },{
--     title: 'Module 1',
--     description: 'This is a module',
--     ref: 'module 1',
--     type: 'module',
--     module: [
--       slides:1,
--       slides:2,
--       slides:5,
--       slides:7,
--       slides:8
--     ]
--   }, {
--     title: 'Slides 1',
--     description: 'This is a slide one',
--     ref: 'slides 1',
--     type: 'slides',
--     slides: [
--       slides:5,
--       slides:3,
--       slides:7,
--       slides:4
--     ]
--   }, {
--     title: 'Slides 2',
--     description: 'This is a slide two',
--     ref: 'slides 2',
--     type: 'slides',
--     slides: [
--       slides:1,
--       slides:4,
--       slides:5,
--       slides:6
--     ]
--   }
-- ];

UPDATE resources:1 CONTENT { description: 'This is a module', module: [slides:1, slides:2, slides:5, slides:7, slides:8], ref: 'module-1', title: 'Module 1', type: 'module' };
UPDATE resources:2 CONTENT { description: 'This is a form', form: [questions:1, questions:2, questions:3, questions:4, questions:5], ref: 'form-1', title: 'Form 1', type: 'form' };
UPDATE resources:3 CONTENT { description: 'This is a slide two', ref: 'slides-2', slides: [slides:1, slides:4, slides:5, slides:6], title: 'Slides 2', type: 'slides' };
UPDATE resources:4 CONTENT { description: 'This is a slide one', ref: 'slides-1', slides: [slides:5, slides:3, slides:7, slides:4], title: 'Slides 1', type: 'slides' };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

