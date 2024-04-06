#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# read the file from a host-mounted volume
cat /files/hello.txt
# write data to a host-mounted volume
echo "ok" > /data/ok.txt
