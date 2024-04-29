DEFINE FUNCTION fn::execute_actions($user: object, $paper: option<object>) {
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

-- resource_add
    IF $actions.action = "resource_add" {
      FOR $ref IN $actions.params {
        -- validation

        -- get resource
        LET $resource_id = (SELECT VALUE id FROM resources WHERE ref = $ref)[0];

        -- create paper
        CREATE papers CONTENT { lock: false, user: <record> $user.id, resource: $resource_id };
      };
    };

-- state_set
    IF $actions.action = "state_set" {
      LET $state = $actions.params;
      LET $id = <record> $user.id;

      UPDATE $id SET state = $state;
    };

-- -- user_active
--     IF $actions.action = "user_active" {
--       -- validation
--       LET $id = <record> $user.id;
-- 
--       --
--       UPDATE $id SET active = true;
--     };
-- 
-- -- user_unactive
--     IF $actions.action = "user_unactive" {
--       -- validation
-- 
--       --
--       UPDATE $id SET active = false;
--     };
-- 
-- -- user_completed
--     IF $actions.action = "user_completed" {
--       -- validation
--       LET $id = <record> $user.id;
-- 
--       --
--       UPDATE $id SET active = false, completed = true;
--     };

-- -- user_exit
--     IF $actions.action = "user_exit" {
--       -- validation
--       LET $id = <record> $user.id;
-- 
--       --
--     };

-- message_send
    IF $actions.action = "message_send" {
      -- validation

    };
  };

  -- RETURN $paper;
};
