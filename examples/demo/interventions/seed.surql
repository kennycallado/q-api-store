-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: scripts
-- ------------------------------

UPDATE users:1 SET active = true;

-- ------------------------------
-- TABLE DATA: locales
-- ------------------------------

INSERT INTO locales [{locale: 'vl'}, {locale: 'es'}, {locale: 'en'}];

-- ------------------------------
-- TABLE DATA: media
-- ------------------------------

UPDATE media:1 CONTENT { alt: 'Google logo', type: 'image', url: 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png' };
UPDATE media:2 CONTENT { alt: 'Youtube vídeo', type: 'video', url: 'https://www.youtube.com/watch?v=FoMlSB6ftQg' };

-- ------------------------------
-- TABLE DATA: questions
-- ------------------------------

UPDATE questions:1 CONTENT { id: questions:1, question: [{ content: '¿Con qué frecuencia te sientes capaz de superar con éxito los desafíos?', locale: 'es', spelled: ['n/c', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente'] }, { content: 'How often do you feel capable of successfully overcoming challenges?', locale: 'en', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally'] }], range: { max: 7, min: 1, value: 0 }, type: 'range' };
UPDATE questions:2 CONTENT { id: questions:2, question: [{ content: '¿Con qué frecuencia sientes que tienes el poder para hacer cambios positivos en tu vida?', locale: 'es', spelled: ['n/c', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente'] }, { content: 'How often do you feel you have the power to make positive changes in your life?', locale: 'en', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally'] }], range: { max: 7, min: 1, value: 0 }, type: 'range' };
UPDATE questions:3 CONTENT { id: questions:3, question: [{ content: '¿Con qué frecuencia sientes que puedes tomar decisiones sabias?', locale: 'es', spelled: ['n/c', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente'] }, { content: 'How often do you feel you are able to make wise decisions?', locale: 'en', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally'] }], range: { max: 7, min: 1, value: 0 }, type: 'range' };
UPDATE questions:4 CONTENT { id: questions:4, question: [{ content: '¿Con qué frecuencia te sientes seguro de tu capacidad para alcanzar tus metas?', locale: 'es', spelled: ['n/c', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente'] }, { content: 'How often do you feel confident in your ability to achieve your goals?', locale: 'en', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally'] }], range: { max: 7, min: 1, value: 0 }, type: 'range' };
UPDATE questions:5 CONTENT { id: questions:5, question: [{ content: '¿Con qué frecuencia sientes que tienes la fuerza para mantener la resiliencia en situaciones difíciles?', locale: 'es', spelled: ['n/c', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente'] }, { content: 'How often do you feel you have the strength to stay resilient in difficult situations?', locale: 'en', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally'] }], range: { max: 7, min: 1, value: 0 }, type: 'range' };

-- ------------------------------
-- TABLE DATA: slides
-- ------------------------------

UPDATE slides:1 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', id: slides:1, media: media:2, title: 'Slide 3', type: 'content' };
UPDATE slides:2 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 1', type: 'content' };
UPDATE slides:3 CONTENT { question: questions:1, title: 'Slide 8', type: 'input' };
UPDATE slides:4 CONTENT { question: questions:2, title: 'Slide 7', type: 'input' };
UPDATE slides:5 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 4', type: 'content' };
UPDATE slides:6 CONTENT { question: questions:3, title: 'Slide 6', type: 'input' };
UPDATE slides:7 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 5', type: 'content' };
UPDATE slides:8 CONTENT { content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 2', type: 'content' };

-- ------------------------------
-- TABLE DATA: resources
-- ------------------------------

UPDATE resources:1 CONTENT { description: 'This is a module', module: [slides:1, slides:2, slides:5, slides:7, slides:8], ref: 'module-1', title: 'Module 1', type: 'module' };
UPDATE resources:2 CONTENT { description: 'This is a form', form: [questions:1, questions:2, questions:3, questions:4, questions:5], ref: 'form-1', title: 'Form 1', type: 'form' };
UPDATE resources:3 CONTENT { description: 'This is a slide two', ref: 'slides-2', slides: [slides:1, slides:4, slides:5, slides:6], title: 'Slides 2', type: 'slides' };
UPDATE resources:4 CONTENT { description: 'This is a slide one', ref: 'slides-1', slides: [slides:5, slides:3, slides:7, slides:4], title: 'Slides 1', type: 'slides' };

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

