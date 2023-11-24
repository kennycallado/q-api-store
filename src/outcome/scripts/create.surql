-- CREATE scripts:1 CONTENT {
--   name: "push",
--   code: "console.log('hello world')"
-- };

UPDATE scripts:1 CONTENT { code: "console.log('hello form function')", id: scripts:1, name: 'push' };

UPDATE scripts:1 CONTENT { code: '
switch(user.score.step) {
  case 1:
    console.log("Reached step 1")
    break;

  case undefined:
    user.actions.push({ action: "add_resource", params: ["form-1"] });
    console.log("Resource added asynchronously");

    user.score = { step: 1 , mood: 0 , state: "ignition" };
    break;

  default:
    console.log("Reached default case");
    break;
}', id: scripts:1, name: 'push' };
