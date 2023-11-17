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
