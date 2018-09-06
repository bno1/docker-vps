#!/bin/bash

if [ ! -f /app-services/irc.yaml ]; then
    matrix-appservice-irc -r -f /app-services/irc.yaml -u "http://matrix-irc:9999" -c /data/config.yaml -l "$MATRIX_IRC_BOTNAME"
fi

exec matrix-appservice-irc -c /data/config.yaml -f /app-services/irc.yaml -p 9999
