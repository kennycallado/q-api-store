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
