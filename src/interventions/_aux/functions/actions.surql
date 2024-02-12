DEFINE FUNCTION fn::execute_actions($paper: option<object>, $user: object) {
  -- validation
  -- paper could be {}
  -- IF $user.actions = NONE { RETURN $paper };
  -- IF $user.id = NONE { RETURN $paper };

  FOR $actions IN $user.actions {
-- resource_completed
    IF $actions.action = "resource_completed" {
      FOR $ref IN $actions.params {
        -- validation

        -- get resource
        LET $resource_id = (SELECT VALUE id FROM resources WHERE ref = $ref)[0];

        -- update paper
        IF $paper.resource = $resource_id {
          UPDATE $paper.id SET lock = false, completed = true;
        } ELSE {
          -- can fails if the ref is not found
          LET $foo = (SELECT id, created FROM papers WHERE resource = $resource_id ORDER BY created DESC LIMIT 1)[0].id;
          UPDATE $foo SET lock = false, completed = true;
        };
      };
    };

-- add_resource
    IF $actions.action = "add_resource" {
      FOR $ref IN $actions.params {
        -- validation

        -- get resource
        LET $resource_id = (SELECT VALUE id FROM resources WHERE ref = $ref)[0];

        -- create paper
        CREATE papers CONTENT { lock: false, user: <record> $user.id, resource: $resource_id };
      };
    };

-- toggle_active
    IF $actions.action = "toggle_active" {
      UPDATE $user.id SET active = !active;
    };

-- user_active
    IF $actions.action = "user_active" {
      -- validation

    };

-- user_unactive
    IF $actions.action = "user_unactive" {
      -- validation

    };

-- send_message
    IF $actions.action = "send_message" {
      -- validation

    };
  };

  -- RETURN $paper;
};
