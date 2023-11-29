
-- ------------------------------
-- TRANSACTION
-- ------------------------------

BEGIN TRANSACTION;

-- ------------------------------
-- TABLE DATA: outcome/scripts
-- ------------------------------

UPDATE scripts:1 CONTENT { code: '
switch(user.score.step) {
  case 1:
    user.actions.push({ action: "resource_completed", params: ["module-1"] });
    user.actions.push({ action: "add_resource", params: ["form-1"] });

    user.score = { step: 2, mood: 0, state: "lift-off" };
    break;

  case 2:
    user.actions.push({ action: "resource_completed", params: ["form-1"] });
    user.actions.push({ action: "add_resource", params: ["slides-1"] });
    user.actions.push({ action: "add_resource", params: ["slides-2"] });

    user.score = { step: 3, mood: 0 };
    break;

  case 4:
    console.log("completed")

    user.score = { step: 5, mood: 0, state: "landed" };
    break;

  default:
    console.error("Reached default case");
    break;
}', name: 'push' };

---------

UPDATE scripts:2 CONTENT { code: '
switch(user.score.step) {
  case 3:
    user.actions.push({ action: "resource_completed", params: ["slides-1"] });
    user.actions.push({ action: "resource_completed", params: ["slides-2"] });

    user.score = { step: 4, mood: 0, state: "orbit" };
    break;

  case undefined:
    user.actions.push({ action: "add_resource", params: ["module-1"] });

    user.score = { step: 1, mood: 0, state: "ignition" };
    break;

  default:
    console.log("Reached default case");
    break;
}', name: 'steps' };

-- ------------------------------
-- TABLE DATA: outcome/functions
-- ------------------------------


-- ------------------------------
-- TABLE DATA: outcome/answers
-- ------------------------------

-- CREATE answers:1 CONTENT {
--   answer: "1",
--   question: questions:1,
-- };

-- CREATE answers:2 CONTENT {
--   answer: "10",
--   question: questions:2,
-- };

UPDATE answers:1 CONTENT { answer: '1', id: answers:1, question: questions:1 };
UPDATE answers:2 CONTENT { answer: '10', id: answers:2, question: questions:2 };

-- ------------------------------
-- TABLE DATA: outcome/papers
-- ------------------------------

-- CREATE papers:1 CONTENT {
--   user: users:1,
--   resource: resources:1,
-- };

UPDATE papers:1 CONTENT { answers: [], completed: false, id: papers:1, resource: resources:1, r_ref: 'module-1', user: users:1 };

-- ------------------------------
-- TABLE DATA: outcome/scores
-- ------------------------------


-- ------------------------------
-- TRANSACTION
-- ------------------------------

COMMIT TRANSACTION;

