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
VOL_PATHS=("/data")
for VOL_PATH in "${VOL_PATHS[@]}"; do
    if [[ ! "$(stat -c %u "${VOL_PATH}")" == "${PUID}" ]]; then
        echo "Change in ownership detected, please wait while permissions are updated"
        matchown -R abc:abc "${VOL_PATH}"
    fi
done

su - abc
exec "$@"
