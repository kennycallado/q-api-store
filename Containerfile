FROM surrealdb/surrealdb:1.0.0

COPY ./data /data

ENTRYPOINT ["/surreal", "start", "file://data/surdb.db", "--auth"]
