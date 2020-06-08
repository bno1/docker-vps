#!/bin/bash

set -e

SEAFILE_DIR=$1

echo "Got seafile directory: \"$SEAFILE_DIR\""

if [ -z "$SEAFILE_DIR" ]; then
    echo "Error: empty seafile directory"
    exit 1
fi

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

CONF_DIRS=(conf ccnet seafile-data seahub-data)

cd /seafile
mkdir -p ./data

for cf in ${CONF_DIRS[@]}; do
    if [ -L "$cf" ] && [ ! -e "$cf"]; then
        rm -f "$cf"
    fi
done

if [ ! -e ./conf ] || [ ! -e ./data/conf ]; then
    patch -p0 < ./setup.patch
    "./$SEAFILE_DIR/setup-seafile-mysql.sh" \
        auto \
        -n "$SEAFILE_SERVER_NAME" \
        -i "$SEAFILE_DOMAIN" \
        -p "$SEAFILE_PORT" \
        -d /seafile/seafile-data \
        -o "$SEAFILE_MYSQL_HOST" \
        -t 3306 \
        -u "seafile" \
        -w "$SEAFILE_DB_PASSWORD" \
	-q "127.0.0.1" \
	-r "notallowed" \
        -c "ccnet_db" \
        -s "seafile_db" \
        -b "seahub_db"

    if [ -n "$SEAFILE_WEB_WORKERS" ]; then
        sed -i "s/workers\s*=\s*[0-9]\+/workers = $SEAFILE_WEB_WORKERS/g" conf/gunicorn.conf.py
    fi

    sed -i 's/bind = "127\.0\.0\.1:8000"/bind = "0.0.0.0:8000"/g' conf/gunicorn.conf.py
    sed -i "s/SERVICE_URL\s*=.*/SERVICE_URL = https:\/\/$SEAFILE_DOMAIN:8000/g" conf/ccnet.conf

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
