switch(user.score.step) {
  case 1:
    console.log("Reached step 1")
    break;

  case undefined:
    // user.add_resource($resource_id_1);
    // user.send_message(3);

    user.actions.push({ action: "add_resource", params: ['module-1'] });
    console.log("Resource added asynchronously")

    user.score = { step: 1, mood: 0, state: "ignition" };
    break;

  default:
    console.log("Reached default case")
    break;
}
