# TODO:

- [ ] interv_users: execute fn::on_init and fn::on_done by events
  - I think it is more performance because they are spawn

- [ ] test: when create demo image test data is correct

- [~] join: ?? assert waits projects has keys... take a look at CONTAINSALL
  - [ ] steel there --- when inter user completed join doesn't update steel there --- when inter user completed join doesn't update
- [~] build: seems execute seed before super is ready

- [X] join: assert project.keys are in score
- [X] version: consider getting 0.2.0
- [X] build: ?? also needs to run super
- [ ] events: super should use cronjobs table intead of update events
- [X] jobs: should be called cronjobs

- [?] global: users maybe DEFAULT (SELECT VALUE name FROM roles WHERE default = true LIMIT 1)
- [X] both: users role field

- [ ] scopes: ?? session duration revision
- [ ] permissions: need a revision, research $auth.id, $session.sd, $token

- [X] global: user ident just unique username
- [ ] global: devices table to relate with users

- [ ] toggle_active ??

- [?] create a client db for migrations
  - [ ] main: change main for server
  - [ ] client: create client migrations (?no extras)
  - [ ] admin: create admint migrations  (?some extras)

- [X] seed: fix evetns injection
- [X] seed: first check if the example exists
- [~] $secret: inject secret, needed for papers...
  - ?? should be defined on a job
  - ?? should be copied when seed a new database

- [X] shared: a table to declare dependencies ???
  - not sure that it is needed.. when move to shared
    copy all dependencies...
- [X] global: rename user_project to global
- [X] scripts: ??? should be at content
- [X] scope: there are some places like **answers** where
             the users will be no able to access from
             the server.
- [ ] 0.2.0: ??? wrap with rust
- [X] seed: repensar como debe funcionar examples y seed
- [ ] resources: optional script, result of the script in the paper?
- [X] slides: add media:2 to slides:1
- [X] ? gitignore dump and seeds ?
- [X] surrealdb: version nightly until 1.1.0
- [X] functions: change them to match 1.0.0 or wait until bug fixed
  - go with nightly knowing that there is a problem with the select live
- [X] questions: ??? spelled answers should be in question.range
  - [?] question.*.options or spelled ??
- [X] record: change name to score

