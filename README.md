
# q_api-resources

## TODO:
- [ ] WARNING: diferenciar lógica servidor de lógica cliente
  - la función on_push para testing necesito que funcione aquí
    pero en realidad es parte de la lógica de cliente
- [ ] all: everything in the same database
- [ ] answers: ??? spellanswers should be in question.range
- [X] papers: created to be able to sort
- [X] record: change name to score

## Notes
- Define $project
- [X] ensure use '--auth' in producction
- `data/` needs wide permissions like 777...
  - for better use --user 1000:1000
- Every proyect is going to generate a ns with the name of the proyect id.
- Authentication, for dev I have it off, take care on deploy.
- Whats the way to store in a file?

## Server

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

## Populate

## Build

## Deploy
