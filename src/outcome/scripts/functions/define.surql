-- LET $class_user = "
-- class User {
--   id;
--   record;
--   paper;
--   actions = [];

--   constructor(paper, record) {
--     this.id = paper.user;
--     this.record = record;
--     this.paper = paper;
--   }
-- }
-- ";

DEFINE FUNCTION fn::on_push($paper: object) {
  -- ensure argument is a paper object
  IF meta::tb($paper.id) != "papers" { THROW "\n\tArgument is not a paper" };

  LET $script = (SELECT VALUE code FROM scripts WHERE name = "push");
  LET $record = (SELECT * FROM records WHERE user = $paper.user ORDER BY created DESC LIMIT 1)[0];

  function($script, $paper, $record) {
    const [script, paper, record] = arguments;

    const classUser = `class User {
      id;
      record;
      paper;
      actions = [];

      constructor(paper, record) {
        this.id = paper.user;
        this.record = record;
        this.paper = paper;
      }
    }`;

    const user = Function(`
      ${classUser};
      const surrealdb = null;
      const user = new User(${JSON.stringify(paper)}, ${JSON.stringify(record)});
      user.actions.push({ action: "resource_completed", params: [user.paper.resource] });
      ${script};
      return user
    `)();

    // update record
    // execute actions

    if (user.actions.len > 0) {
      if (user.actions[0].action == "resource_completed") {
        (await surrealdb.query(``))
      }
    }

  }
};

--   $script = "(async () => { console.log( await surrealdb.query('SELECT * FROM projects') ) })()";
--   // LET $script = (SELECT VALUE script FROM $project);

--   function($code, $script) {
--     const [code, script] = arguments;

--     // ensure surrealdb is not accessible from the outside
--     Function(`const surrealdb = null; ${script}`)();
--   };
-- };

-- fn::test("console.log('hola')", []);
