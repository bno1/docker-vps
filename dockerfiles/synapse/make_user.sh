#!/bin/bash

set -e

register_new_matrix_user -c /data/homeserver.yaml $@ http://localhost:8008
