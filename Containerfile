FROM surrealdb/surrealdb:v1.2.1

COPY ./data /data

ENTRYPOINT ["/surreal", "start", "file://data/surdb.db", "--auth"]
