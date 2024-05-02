# q_api-resources

## Notes
- Every proyect is going to generate a db in projects ns
- Authentication, for dev I have it off, take care on deploy.

## Todos:

[link](TODO.md)

---

**warning**: project can't be named main

### NS:

- global
- interventions

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
- resource_add
- send_message
- user_active
- user_unactive
- user_done

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
podman exec -it surrealdb /surreal sql --pretty --ns interventions --db <db>
```

## Initialize

``` bash
bash init.sh
```

## Seed

``` bash
bash seed.sh demo
```

## Build

``` bash
bash build.sh
```

## Deploy
