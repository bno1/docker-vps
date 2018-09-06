#!/bin/bash

set -e

registration_new_matrix_user -c /data/homeserver.yaml $@ http://localhost:8008
