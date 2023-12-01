FROM surrealdb/surrealdb:1.0.0
# FROM surrealdb/surrealdb:nightly

COPY ./data /data

ENTRYPOINT ["/surreal", "start", "file://data/surdb.db", "--auth"]
