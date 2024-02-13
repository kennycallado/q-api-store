FROM surrealdb/surrealdb:v1.2.0

COPY ./data /data

ENTRYPOINT ["/surreal", "start", "file://data/surdb.db", "--auth"]
