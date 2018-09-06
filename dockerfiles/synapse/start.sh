#!/bin/bash

set -ex

envsubst '${SYNAPSE_DB_PASSWORD} ${SYNAPSE_POSTGRES_HOST} ${SYNAPSE_PEPPER}' < /data/homeserver.yaml.template > /data/homeserver.yaml

exec python -m synapse.app.homeserver -c /data/homeserver.yaml
