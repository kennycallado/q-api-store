# FROM surrealdb/surrealdb:nightly
FROM surrealdb/surrealdb:v1.1.1

COPY ./data /data

ENTRYPOINT ["/surreal", "start", "file://data/surdb.db", "--auth"]
