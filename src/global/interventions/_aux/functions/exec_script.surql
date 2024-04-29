DEFINE FUNCTION fn::execute_script($script: string, $user_id: record<users>, $paper: option<object>) {
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

      resource_add(...resource_ref) {
        if (typeof resource_ref[0] !== "string") {
          resource_ref = resource_ref[0]
        }

        this.actions.push({ action: "resource_add", params: resource_ref })
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

      state_set(state) {
        if (state === 'active' || state === 'standby' || state === 'completed' || state === 'exit') {
          this.actions.push({ action: "state_set", params: state })
        } else throw new Error('Invalid state')
      }

      message_send(message_id) {
        this.actions.push({ action: "message_send", params: message_id })
      }

      /**
      active() {
        this.actions.push({ action: "user_active", params: [] })
      }

      unactive() {
        this.actions.push({ action: "user_unactive", params: [] })
      }

      completed() {
        this.actions.push({ action: "user_completed", params: [] })
      }

      exit() {
        this.actions.push({ action: "user_exit", params: [] })
      }
      */
    }`;

    return Function(`
      ${classUser};
      const surrealdb = null;
      const user = new User(${JSON.stringify(user_id)}, ${JSON.stringify(paper)}, ${JSON.stringify(score)});
      ${script};

      // user.actions.push({ action: "resource_completed", params: ['module-1'] });
      // user.actions.push({ action: "resource_add", params: ['form-1'] });
      // user.actions.push({ action: "user_unactive", params: [] });
      // user.score = {mood: "100"};

      return user;
    `)();
  };

  RETURN $user
};
