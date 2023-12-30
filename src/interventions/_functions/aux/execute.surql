DEFINE FUNCTION fn::execute($script: string, $user_id: record<users>, $paper: option<object>) {
  -- validation
  -- paper optional because of on_cron could recive users whithout paper

  -- prepare score
  LET $score = (SELECT * FROM scores WHERE user = $user_id ORDER BY created DESC LIMIT 1).score;

  LET $user = function($user_id, $script, $paper, $score[0]) {
    const [user_id, script, paper, score] = arguments;

    const classUser = `class User {
      id;
      score;
      paper;
      actions = [];

      constructor(id, paper, score = Object.create(null)) {
        this.id = id;
        this.score = score;
        this.paper = paper;
      }

      add_resource(...resource_ref) {
        if (typeof resource_ref[0] !== "string") {
          resource_ref = resource_ref[0]
        }

        this.actions.push({ action: "add_resource", params: resource_ref })
      }

      resource_completed(...resource_ids) {
        if (typeof resource_ids[0] !== "string") {
          resource_ids = resource_ids[0]
        }

        if (!resource_ids || resource_ids.length === 0) {
          this.actions.push({ action: "resource_completed", params: [this.paper.resource_id] })
        }

        this.actions.push({ action: "resource_completed", params: resource_ids })
      }

      send_message(message_id) {
        this.actions.push({ action: "send_message", params: [message_id] })
      }
    }`;

    return Function(`
      ${classUser};
      const surrealdb = null;
      const user = new User(${JSON.stringify(user_id)}, ${JSON.stringify(paper)}, ${JSON.stringify(score)});
      ${script};

      // user.actions.push({ action: "resource_completed", params: ['module-1'] });
      // user.actions.push({ action: "add_resource", params: ['form-1'] });
      // user.actions.push({ action: "user_unactive", params: [] });
      // user.score = {mood: "100"};

      return user;
    `)();
  };

  RETURN $user
};
