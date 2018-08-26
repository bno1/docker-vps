#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 <<-EOSQL
    CREATE USER seafile WITH PASSWORD '$SEAFILE_DB_PASSWORD';
    CREATE DATABASE ccnet_db;
    CREATE DATABASE seafile_db;
    CREATE DATABASE seahub_db;
    GRANT ALL PRIVILEGES ON DATABASE ccnet_db TO seafile;
    GRANT ALL PRIVILEGES ON DATABASE seafile_db TO seafile;
    GRANT ALL PRIVILEGES ON DATABASE seahub_db TO seafile;
EOSQL
