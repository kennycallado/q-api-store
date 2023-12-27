
q_api-resources

**warning**: project can't be named main

### NS:

- interventions
- user_project

#### _functions:

#### DB:

For every project there will be a database

#### tables:

- users

- locales
- media
- questions
- resoruces
- slides

- scripts

- answers
- papers
- scores

### Events:

- **cron** (chronological script execution)
- **done** (user finishes the intervention)
- **init** (user joins the project)
- **push** (user completes a resource)

### Scripts:

? maybe able to manage an intervention without scripts

- **????** 
- **done**
- **init**
- **push**

### Actions:

- resource_completed
- add_resource
- send_message
- user_active
- user_unactive
- user_done

## TODO:

- [ ] user_project: user.project should be equal
- [ ] seed: repensar como debe funcionar examples y seed
- [ ] DOCS: improve the docs
- [ ] resources: optional script, result of the script in the paper?
- [ ] 0.2.0: ??? wrap with rust
- [X] slides: add media:2 to slides:1
- [X] ? gitignore dump and seeds ?
- [X] surrealdb: version nightly until 1.1.0
- [X] functions: change them to match 1.0.0 or wait until bug fixed
  - go with nightly knowing that there is a problem with the select live
- [X] questions: ??? spelled answers should be in question.range
  - [?] question.*.options or spelled ??
- [X] record: change name to score

## Notes
- Every proyect is going to generate a db in projects ns
- Authentication, for dev I have it off, take care on deploy.

## Dev Server

``` bash
surreal start memory --no-banner -A --auth --user root --pass root
```

``` bash
podman compose up
```

## Repl

``` bash
surreal sql --pretty -u root -p root --ns main --db <db>
```

``` bash
podmas exec -it surrealdb /surreal sql --pretty --ns main --db <db>
```

## Initialize

``` bash
bash init.sh
```

Then repl to create a project and user:

``` surql
CREATE projects:1 SET name = 'demo';
CREATE users:1 SET project = projects:1;
```

## Populate

``` bash
bash postinit.sh
```

## Build

``` bash
bash build.sh
```

## Deploy
