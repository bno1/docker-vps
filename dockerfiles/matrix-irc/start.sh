#!/bin/bash

BIN="$HOME/matrix-appservice-irc/bin/matrix-appservice-irc"

if [ ! -f /app-services/irc.yaml ]; then
    "$BIN" -r -f /app-services/irc.yaml -u "http://matrix-irc:9999" -c /data/config.yaml -l "$MATRIX_IRC_BOTNAME"
fi

exec "$BIN" -c /data/config.yaml -f /app-services/irc.yaml -p 9999
