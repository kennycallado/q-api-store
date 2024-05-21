ARG version=latest
FROM surrealdb/surrealdb:${version}

COPY ./data /data

ENTRYPOINT ["/surreal", "start", "file://data/surdb.db", "--auth"]
