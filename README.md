
# q_api-resources

## TODO:
- [ ] ? gitignore dump and seeds ?
- [ ] surrealdb: version nightly until 1.1.0
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
docker compose up
```

## Repl

``` bash
surreal sql --pretty -u root -p root --ns main --db <db>
```

``` bash
docker exec -it surrealdb /surreal sql --pretty --ns main --db <db>
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
