-- return the current paper
DEFINE FUNCTION fn::actions($paper: option<object>, $user: object) {
  -- validation
  -- paper could be {}
  -- IF $user.actions = NONE { RETURN $paper };
  -- IF $user.id = NONE { RETURN $paper };

  FOR $action IN $user.actions {
-- resource_completed
    IF $action.action = "resource_completed" {
      FOR $ref IN $action.params {
        -- validation

        -- get resource
        LET $resource_id = (SELECT VALUE id FROM resources WHERE ref = $ref)[0];

        -- update paper
        IF $paper.resource = $resource.id {
          UPDATE $paper.id SET completed = true;
        } ELSE {
          -- can fails if the ref is not found
          UPDATE (SELECT id, created FROM papers WHERE resource = $resource_id ORDER BY created DESC LIMIT 1)[0].id SET completed = true;
        };

      };
    };

-- add_resource
    if $action.action = "add_resource" {
      function($action) { const [action] = arguments; console.log(action) };
      for $ref in $action.params {
        -- validation

        -- get resource
        LET $resource_id = (SELECT VALUE id FROM resources WHERE ref = $ref)[0];

        -- create paper
        CREATE papers CONTENT { user: type::thing($user.id), resource: $resource_id, lock: false };
      };
    };

-- toggle_active
    if $action.action = "toggle_active" {
      UPDATE $user.id SET active = !active;
    };

-- user_active
    if $action.action = "user_active" {
      -- validation

    };

-- user_unactive
    if $action.action = "user_unactive" {
      -- validation

    };

-- send_message
    if $action.action = "send_message" {
      -- validation

    };
  };

  RETURN $paper;
};
