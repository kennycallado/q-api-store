-- SEED --

-- ------------------------------
-- OPTION
-- ------------------------------

-- OPTION IMPORT;

USE NS demo DB demo;

-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: locales
-- ------------------------------

INSERT INTO locales [{locale: 'ca'}, {locale: 'es'}, {locale: 'en'}];

-- ------------------------------
-- TABLE DATA: media
-- ------------------------------

UPDATE media:m1 CONTENT {id: media:m1, alt: 'Google logo', ref: 'google-logo', type: 'image', url: 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'};
UPDATE media:m2 CONTENT {id: media:m2, ref: 'youtube-video', alt: 'Youtube vídeo', type: 'video', url: 'https://www.youtube.com/watch?v=FoMlSB6ftQg'};

-- ------------------------------
-- TABLE DATA: paragraphs
-- ------------------------------

UPDATE paragraphs:p1 CONTENT {id: paragraphs:p1, content: [{text: 'Título', locale: 'es'}, {text: 'Títle', locale: 'en'}], type: 'h2', ref: 'demo-titulo'};
UPDATE paragraphs:p2 CONTENT {id: paragraphs:p2, content: [{text: 'Subtítulo', locale: 'es'}, {text: 'Subtitle', locale: 'en'}], type: 'h3', ref: 'demo-subtitulo'};
UPDATE paragraphs:p3 CONTENT {id: paragraphs:p3, content: [{text: 'Texto 1', locale: 'es'}, {text: 'Text 1', locale: 'en'}], type: 'text', ref: 'demo-text-1'};
UPDATE paragraphs:p4 CONTENT {id: paragraphs:p4, content: [{text: 'Texto 2', locale: 'es'}, {text: 'Text 2', locale: 'en'}], type: 'text', ref: 'demo-text-2'};
UPDATE paragraphs:p5 CONTENT {id: paragraphs:p5, content: [{text: 'Texto 3', locale: 'es'}, {text: 'Text 3', locale: 'en'}], type: 'text', ref: 'demo-text-3'};

-- ------------------------------
-- TABLE DATA: questions
-- ------------------------------

UPDATE questions:q1 CONTENT {id: questions:q1, ref: 'question-uno', question: [{content: 'Amb quina freqüència et sents capaç de superar amb èxit els reptes?', locale: 'ca', spelled: ['n/c', 'Res', 'Poc', 'Mitjana', 'Bastant', 'Molt', 'Totalment']}, {content: '¿Con qué frecuencia te sientes capaz de superar con éxito los desafíos?', locale: 'es', spelled: ['n/c', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente']}, {content: 'How often do you feel capable of successfully overcoming challenges?', locale: 'en', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally']}], range: {max: 7, min: 1, value: 0}, type: 'range'};
UPDATE questions:q2 CONTENT {id: questions:q2, ref: 'question-dos', question: [{content: 'Amb quina freqüència sents que tens el poder per fer canvis positius a la teva vida?', locale: 'ca', spelled: ['n/c', 'Res', 'Poc', 'Mitjana', 'Bastant', 'Molt', 'Totalment']}, {content: '¿Con qué frecuencia sientes que tienes el poder para hacer cambios positivos en tu vida?', locale: 'es', spelled: ['n/c', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente']}, {content: 'How often do you feel you have the power to make positive changes in your life?', locale: 'en', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally']}], range: {max: 7, min: 1, value: 0}, type: 'range'};
UPDATE questions:q3 CONTENT {id: questions:q3, ref: 'question-tres', question: [{content: 'Amb quina freqüència sents que pots prendre decisions sàvies?', locale: 'ca', spelled: ['n/c', 'Res', 'Poc', 'Mitjana', 'Bastant', 'Molt', 'Totalment']}, {content: '¿Con qué frecuencia sientes que puedes tomar decisiones sabias?', locale: 'es', spelled: ['n/c', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente']}, {content: 'How often do you feel you are able to make wise decisions?', locale: 'en', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally']}], range: {max: 7, min: 1, value: 0 }, type: 'range' };
UPDATE questions:q4 CONTENT {id: questions:q4, ref: 'question-cuatro', question: [{content: 'Amb quina freqüència et sents segur de la teva capacitat per assolir els teus objectius?', locale: 'ca', spelled: ['n/c', 'Res', 'Poc', 'Mitjana', 'Bastant', 'Molt', 'Totalment']}, {content: '¿Con qué frecuencia te sientes seguro de tu capacidad para alcanzar tus metas?', locale: 'es', spelled: ['n/c', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente']}, {content: 'How often do you feel confident in your ability to achieve your goals?', locale: 'en', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally']}], range: {max: 7, min: 1, value: 0}, type: 'range'};
UPDATE questions:q5 CONTENT {id: questions:q5, ref: 'question-cinco', question: [{content: 'Amb quina freqüència sents que tens la força per mantenir la resiliència en situacions difícils?', locale: 'ca', spelled: ['n/c', 'Res', 'Poc', 'Mitjana', 'Bastant', 'Molt', 'Totalment']}, {content: '¿Con qué frecuencia sientes que tienes la fuerza para mantener la resiliencia en situaciones difíciles?', locale: 'es', spelled: ['n/c', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente']}, {content: 'How often do you feel you have the strength to stay resilient in difficult situations?', locale: 'en', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally']}], range: {max: 7, min: 1, value: 0}, type: 'range'};

-- UPDATE questions:6 CONTENT { id: questions:6, question: [{ content: 'Amb quina freqüència sents que tens la força per mantenir la resiliència en situacions difícils?', locale: 'ca', spelled: ['n/c', 'Res', 'Poc', 'Mitjana', 'Bastant', 'Molt', 'Totalment'] }, { content: '¿Con qué frecuencia sientes que tienes la fuerza para mantener la resiliencia en situaciones difíciles?', locale: 'es', spelled: ['n/c', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente'] }, { content: 'How often do you feel you have the strength to stay resilient in difficult situations?', locale: 'en', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally'] }], range: { max: 7, min: 1, value: 0 }, type: 'range' };

-- ------------------------------
-- TABLE DATA: slides
-- ------------------------------

UPDATE slides:s1 CONTENT {id: slides:s1, ref: 'slide-one', content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', media: media:m2, title: 'Slide 3', type: 'content'};
UPDATE slides:s2 CONTENT {id: slides:s2, ref: 'slide-two', content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 1', type: 'content'};
UPDATE slides:s3 CONTENT {id: slides:s3, ref: 'slide-three', question: questions:q1, title: 'Slide 8', type: 'input'};
UPDATE slides:s4 CONTENT {id: slides:s4, ref: 'slide-four', question: questions:q2, title: 'Slide 7', type: 'input'};
UPDATE slides:s5 CONTENT {id: slides:s5, ref: 'slide-five', content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 4', type: 'content'};
UPDATE slides:s6 CONTENT {id: slides:s6, ref: 'slide-six', question: questions:q3, title: 'Slide 6', type: 'input'};
UPDATE slides:s7 CONTENT {id: slides:s7, ref: 'slide-seven', content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 5', type: 'content'};
UPDATE slides:s8 CONTENT {id: slides:s8, ref: 'slide-eight', content: 'Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.', title: 'Slide 2', type: 'content'};

-- ------------------------------
-- TABLE DATA: resources
-- ------------------------------

UPDATE resources:r1 CONTENT {id: resources:r1, description: 'This is a module', module: [slides:s1, slides:s2, slides:s5, slides:s7, slides:s8], ref: 'module-1', title: 'Module 1', type: 'module'};
UPDATE resources:r2 CONTENT {id: resources:r2, description: 'This is a form', form: [questions:q1, questions:q2, questions:q3, questions:q4, questions:q5], ref: 'form-1', title: 'Form 1', type: 'form'};
UPDATE resources:r3 CONTENT {id: resources:r3, description: 'This is a slide two', ref: 'slides-2', slides: [slides:s1, slides:s4, slides:s5, slides:s6], title: 'Slides 2', type: 'slides'};
UPDATE resources:r4 CONTENT {id: resources:r4, description: 'This is a slide one', ref: 'slides-1', slides: [slides:s5, slides:s3, slides:s7, slides:s4], title: 'Slides 1', type: 'slides'};

-- ------------------------------
-- TABLE DATA: events
-- ------------------------------

UPDATE events:e1 CONTENT {id: events:e1, ref: 'every-minute', schedule: '0 * * * * *', script: 'steps', active: false};

-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

USE NS global DB main;
