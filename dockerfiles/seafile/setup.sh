#!/bin/bash

set -e

function link_file() {
    if [ ! -L "./$1" ]; then
        if [ ! -e "data/$1" ]; then
            mv "./$1" "data/$1"
        else
            rm -r "./$1"
        fi

        ln -s "data/$1" "./$1"
    fi
}

CONF_DIRS=(conf ccnet seafile-data seahub-data seahub.db)

cd /seafile
mkdir -p ./data

for cf in ${CONF_DIRS[@]}; do
    if [ -L "$cf" ] && [ ! -e "$cf"]; then
        rm -f "$cf"
    fi
done

if [ ! -e ./conf ] || [ ! -e ./data/conf ]; then
    ./seafile-server/setup-seafile.sh auto -n "$SEAFILE_SERVER_NAME" -i "$SEAFILE_DOMAIN" -p "$SEAFILE_PORT" -d /seafile/data/storage

    if [ -n "$SEAFILE_WEB_WORKERS" ]; then
        sed -i "s/workers\s*=\s*[0-9]\+/workers = $SEAFILE_WEB_WORKERS/g" conf/gunicorn.conf
    fi

    sed -i 's/bind = "127\.0\.0\.1:8000"/bind = "0.0.0.0:8000"/g' conf/gunicorn.conf
    sed -i "s/SERVICE_URL\s*=.*/SERVICE_URL = https:\/\/$SEAFILE_DOMAIN:8000/g" conf/ccnet.conf

    cat >>conf/ccnet.conf <<EOF

[Database]
ENGINE=pgsql
HOST=$SEAFILE_POSTGRES_HOST
USER=seafile
PASSWD=$SEAFILE_DB_PASSWORD
DB=ccnet_db
EOF

    cat >>conf/seafile.conf <<EOF

[database]
type=pgsql
host=$SEAFILE_POSTGRES_HOST
user=seafile
password=$SEAFILE_DB_PASSWORD
db_name=seafile_db
EOF

    cat >>conf/seahub_settings.py <<EOF

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME' : 'seahub_db',
        'USER' : 'seafile',
        'PASSWORD' : '$SEAFILE_DB_PASSWORD',
        'HOST' : '$SEAFILE_POSTGRES_HOST',
    }
}
EOF

    if [ -n "$SEAFILE_MEMCACHED_HOST" ]; then
        cat >>conf/seahub_settings.py <<EOF

CACHES = {
    'default': {
        'BACKEND': 'django_pylibmc.memcached.PyLibMCCache',
        'LOCATION': '$SEAFILE_MEMCACHED_HOST',
    },
    'locmem': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    },
}
COMPRESS_CACHE_BACKEND = 'locmem'
EOF
    fi

    cat >>conf/seahub_settings.py <<EOF

FILE_SERVER_ROOT = 'https://$SEAFILE_DOMAIN:8000/seafhttp'
EOF

    export CCNET_CONF_DIR=/seafile/ccnet
    export SEAFILE_CENTRAL_CONF_DIR=/seafile/conf
    export SEAFILE_CONF_DIR=/seafile/seafile-data
    INSTALLPATH=/seafile/seafile-server
    export PYTHONPATH=${INSTALLPATH}/seafile/lib64/python2.7/site-packages:${INSTALLPATH}/seahub/thirdpart:$PYTHONPATH
    pushd "$INSTALLPATH/seahub"
    python manage.py makemigrations
    python manage.py migrate --run-syncdb
    popd

    cat >>conf/admin.txt <<EOF
{
  "email": "$SEAFILE_SU_EMAIL",
  "password": "$SEAFILE_SU_PASSWORD"
}
EOF
fi

for cf in ${CONF_DIRS[@]}; do
    link_file "$cf"
done
