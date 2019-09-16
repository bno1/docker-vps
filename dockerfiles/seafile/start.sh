#!/bin/bash

set -e

cd /seafile

./seafile-server-latest/seafile.sh start
./seafile-server-latest/seahub.sh start

retry=0
while [ "$retry" -lt 4 ]; do
    controller=$(ps aux | grep seafile-controller | grep -v grep || true)
    gc=$(ps aux | grep /scripts/gc.sh | grep -v grep || true)

    if [ -z "$controller" ] && [ -z "$gc" ]; then
        echo "Seafile controller gone [$retry]"
        retry=$((retry + 1))
    else
        retry=0
    fi

    sleep 5s
done

echo "Leaving"
