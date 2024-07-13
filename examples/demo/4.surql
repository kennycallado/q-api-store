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

UPDATE questions:q1 CONTENT { content: { questions: [{ locale: 'en', question: 'How often do you feel capable of successfully overcoming challenges?', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally'] }, { locale: 'es', question: '¿Con qué frecuencia te sientes capaz de superar con éxito los desafíos?', spelled: ['n/a', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente'] }, { locale: 'ca', question: 'Amb quina freqüència et sents capaç de superar amb èxit els reptes?', spelled: ['n/a', 'Cap', 'Baixa', 'Mitjana', 'Alta', 'Molt Alta', 'Totalment'] }], range: { max: 7, min: 1, value: 0 } }, id: questions:q1, ref: 'question-uno', type: 'range' };
UPDATE questions:q2 CONTENT { content: { questions: [{ locale: 'en', question: 'How often do you feel you have the power to make positive changes in your life?', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally'] }, { locale: 'es', question: '¿Con qué frecuencia sientes que tienes el poder para hacer cambios positivos en tu vida?', spelled: ['n/a', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente'] }, { locale: 'ca', question: 'Amb quina freqüència sents que tens el poder per fer canvis positius a la teva vida?', spelled: ['n/a', 'Cap', 'Baixa', 'Mitjana', 'Alta', 'Molt Alta', 'Totalment'] }], range: { max: 7, min: 1, value: 0 } }, id: questions:q2, ref: 'question-dos', type: 'range' };
UPDATE questions:q3 CONTENT { content: { questions: [{ locale: 'en', question: 'How often do you feel you are able to make wise decisions?', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally'] }, { locale: 'es', question: '¿Con qué frecuencia sientes que puedes tomar decisiones sabias?', spelled: ['n/a', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente'] }, { locale: 'ca', question: 'Amb quina freqüència sents que pots prendre decisions sàvies?', spelled: ['n/a', 'Cap', 'Baixa', 'Mitjana', 'Alta', 'Molt Alta', 'Totalment'] }], range: { max: 7, min: 1, value: 0 } }, id: questions:q3, ref: 'question-tres', type: 'range' };
UPDATE questions:q4 CONTENT { content: { questions: [{ locale: 'en', question: 'How often do you feel confident in your ability to achieve your goals?', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally'] }, { locale: 'es', question: '¿Con qué frecuencia te sientes seguro de tu capacidad para alcanzar tus metas?', spelled: ['n/a', 'Nada', 'Poco', 'Medio', 'Bastante', 'Mucho', 'Totalmente'] }, { locale: 'ca', question: 'Amb quina freqüència et sents segur de la teva capacitat per assolir els teus objectius?', spelled: ['n/a', 'Cap', 'Baixa', 'Mitjana', 'Alta', 'Molt Alta', 'Totalment'] }], range: { max: 7, min: 1, value: 0 } }, id: questions:q4, ref: 'question-cuatro', type: 'range' };
UPDATE questions:q5 CONTENT { content: { questions: [{ locale: 'en', question: 'How often do you feel you have the strength to stay resilient in difficult situations?', spelled: ['n/a', 'None', 'Low', 'Medium', 'High', 'Very High', 'Totally'] }, { locale: 'es', question: '¿Con qué frecuencia sientes que tienes la fuerza para mantenerte resiliente en situaciones difíciles?', spelled: ['n/a', 'Ninguna', 'Baja', 'Media', 'Alta', 'Muy Alta', 'Totalmente'] }, { locale: 'ca', question: 'Amb quina freqüència sents que tens la força per mantenir-te resilient en situacions difícils?', spelled: ['n/a', 'Cap', 'Baixa', 'Mitjana', 'Alta', 'Molt Alta', 'Totalment'] }], range: { max: 7, min: 1, value: 0 } }, id: questions:q5, ref: 'question-cinco', type: 'range' };
UPDATE questions:q6 CONTENT { content: { questions: [{ locale: 'en', question: 'Describe how do you feel about your ability to stay resilient in difficult situations.' }, { locale: 'es', question: 'Describe cómo te sientes con respecto a tu capacidad para mantenerte resiliente en situaciones difíciles.' }, { locale: 'ca', question: 'Descriu com et sents respecte a la teva capacitat per mantenir-te resilient en situacions difícils.' }], text: { max: 140, min: 10 } }, id: questions:q6, ref: 'question-seis', type: 'text' };
UPDATE questions:q7 CONTENT { content: { questions: [{ locale: 'en', question: 'What are the main reasons that make you feel resilient in difficult situations?' }, { locale: 'es', question: '¿Cuáles son las principales razones que te hacen sentir resiliente en situaciones difíciles?' }, { locale: 'ca', question: 'Quines són les principals raons que et fan sentir resilient en situacions difícils?' }], text: { max: 140, min: 10 } }, id: questions:q7, ref: 'question-siete', type: 'text' };
UPDATE questions:q8 CONTENT { content: { questions: [{ locale: 'en', question: 'What are the main reasons that make you feel less resilient in difficult situations?' }, { locale: 'es', question: '¿Cuáles son las principales razones que te hacen sentir menos resiliente en situaciones difíciles?' }, { locale: 'ca', question: 'Quines són les principals raons que et fan sentir menys resilient en situacions difícils?' }], text: { max: 140, min: 10 } }, id: questions:q8, ref: 'question-ocho', type: 'text' };

-- ------------------------------
-- TABLE DATA: slides
-- ------------------------------

UPDATE slides:s1 CONTENT {id: slides:s1, ref: 'slide-one', title: 'Slide 1', elements: [media:m1, paragraphs:p1, paragraphs:p5]};
UPDATE slides:s2 CONTENT {id: slides:s2, ref: 'slide-two', title: 'Slide 2', elements: [paragraphs:p2, paragraphs:p1, questions:q6, questions:q7, questions:q8]};
UPDATE slides:s3 CONTENT {id: slides:s3, ref: 'slide-three', title: 'Slide 3', elements: [paragraphs:p2, paragraphs:p3, questions:q1]};
UPDATE slides:s4 CONTENT {id: slides:s4, ref: 'slide-four', title: 'Slide 4', elements: [media:m2, paragraphs:p1, questions:q1, questions:q2, questions:q3]};
UPDATE slides:s5 CONTENT {id: slides:s5, ref: 'slide-five', title: 'Slide 5', elements: [media:m1, paragraphs:p2, questions:q4, questions:q5]};

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
