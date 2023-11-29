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
