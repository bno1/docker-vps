FROM postgres:12

ENV PGDATA /var/lib/postgresql/data/12/

COPY seafile-db.sh /docker-entrypoint-initdb.d/
COPY prosody-db.sh /docker-entrypoint-initdb.d/
COPY synapse-db.sh /docker-entrypoint-initdb.d/
