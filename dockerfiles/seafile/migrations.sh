#!/bin/bash

set -e

export CCNET_CONF_DIR=/seafile/ccnet
export SEAFILE_CENTRAL_CONF_DIR=/seafile/conf
export SEAFILE_CONF_DIR=/seafile/seafile-data
INSTALLPATH=/seafile/seafile-server-latest
export PYTHONPATH=${INSTALLPATH}/seafile/lib64/python3.6/site-packages:${INSTALLPATH}/seahub/thirdpart:$PYTHONPATH

cd ${INSTALLPATH}/seahub
python3 manage.py makemigrations
python3 manage.py migrate --run-syncdb
