#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

PUID=${PUID:-911}
PGID=${PGID:-911}

# change user group and id
groupmod -o -g "$PGID" abc
usermod -o -u "$PUID" abc

# update permissions on volumes
if [ -n "${VOLUME_PATHS:-}" ]; then
    # the volumes paths are separated by `:`
    echo "${VOLUME_PATHS}" | tr ':' '\n' | while IFS= read -r VOLUME_PATH; do
        if [[ ! "$(stat -c %u "${VOL_PATH}")" == "${PUID}" ]]; then
            echo "Change in ownership detected, please wait while permissions are updated"
            matchown -R abc:abc "${VOL_PATH}"
        fi
    done
fi

runuser -u abc "$@"
