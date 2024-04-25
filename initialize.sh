#!/bin/bash
set -e
SET_INDEX=${HOSTNAME##*-}
echo "Starting initializing for pod $SET_INDEX"
if [ "$SET_INDEX" = "0" ]; then
  exec ./entrypoint.sh --uri 'http://qdrant-0.qdrant-headless:6335'
else
  exec ./entrypoint.sh --bootstrap 'http://qdrant-0.qdrant-headless:6335' --uri 'http://qdrant-'"$SET_INDEX"'.qdrant-headless:6335'
fi
