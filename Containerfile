# FROM surrealdb/surrealdb:nightly
FROM surrealdb/surrealdb:v1.1.0-beta.3

COPY ./data /data

ENTRYPOINT ["/surreal", "start", "file://data/surdb.db", "--auth"]
