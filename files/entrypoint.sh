#!/bin/bash
# Wrapper script for Avorion server, to serve as the entrypoint
# It is mostly exactly the same as the original server.sh but
# runs the server binary with exec so that signals propagate correctly.

set -euo pipefail

SCRIPTPATH=$( cd "$(dirname "$(readlink -f "$0")")" ; pwd -P )
cd "$SCRIPTPATH"

export LD_LIBRARY_PATH=${SCRIPTPATH}/linux64

exec ./bin/AvorionServer --galaxy-name avorion_galaxy "$@"
