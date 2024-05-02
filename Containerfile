FROM surrealdb/surrealdb:v1.4.2

COPY ./data /data

ENTRYPOINT ["/surreal", "start", "file://data/surdb.db", "--auth"]
