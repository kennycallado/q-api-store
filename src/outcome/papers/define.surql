-- table
DEFINE TABLE papers SCHEMAFULL PERMISSIONS NONE;

-- fields
DEFINE FIELD user       ON TABLE papers TYPE record<users>;
DEFINE FIELD created    ON TABLE papers TYPE datetime DEFAULT time::now();
DEFINE FIELD resource   ON TABLE papers TYPE record<resources>;
DEFINE FIELD completed  ON TABLE papers TYPE bool DEFAULT false;

DEFINE FIELD answers    ON TABLE papers TYPE option<array<record>> DEFAULT [];
DEFINE FIELD answers[*] ON TABLE papers TYPE record<answers>;

-- indexes

-- events
DEFINE EVENT p_create_paper ON TABLE papers WHEN $event IS "CREATE" THEN {
  RELATE $project->create_paper->$value;
};

DEFINE event u_update_paper ON TABLE papers WHEN $event IS "UPDATE" THEN {
  LET $user = $auth.id;

  IF $user != NONE {
    -- prevent user from update something else
    IF $value.completed != $before.completed
    OR $value.resource  != $before.resource
    OR $value.user      != $before.user {
      CREATE logs SET index = $before.id, event = "ERROR: update not allowed", time = time::now();

      THROW "Changes not allowed"
    };

    -- execute script
    fn::on_push($value);
  };

  -- borrar: just for testing
  IF $value.completed = false {
    $blah = fn::on_push($value);
  };

};

DEFINE EVENT papers_log ON TABLE papers WHEN $event IS "CREATE" OR $event IS "UPDATE" OR $event IS "DELETE" THEN {
  IF $event = 'DELETE' {
    CREATE logs SET index = $before.id, event = $event, time = time::now();
  } ELSE {
    CREATE logs SET index = $value.id, event = $event, time = time::now();
  }
};
