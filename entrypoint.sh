#!/bin/bash
set -xe
echo 'connect-timeout = 5' > $HOME/.curlrc
echo 'retry = 5' >> $HOME/.curlrc
echo 'retry-all-errors' >> $HOME/.curlrc

if [ -d /mnt/secrets/certs ]; then
  cp /mnt/secrets/certs/ca.pem /usr/share/pki/trust/anchors/private-ca.pem
  update-ca-certificates
fi

QDRANT_COLLECTION="test_collection"
echo "Connecting to qdrant.default:6333"
QDRANT_URL="http://qdrant.default:6333"
API_KEY_HEADER=""
API_KEY_HEADER="Api-key: true"

# Delete collection if exists
curl -X DELETE -H "${API_KEY_HEADER}" $QDRANT_URL/collections/${QDRANT_COLLECTION}

# Create collection
curl -X PUT \
-H 'Content-Type: application-json' \
-d '{"vectors":{"size":4,"distance":"Dot"}}' \
-H  "${API_KEY_HEADER}" \
$QDRANT_URL/collections/${QDRANT_COLLECTION} --fail-with-body

# Insert points
curl -X PUT \
-H 'Content-Type: application-json' \
-d '{"points":[
  {"id":1,"vector":[0.05, 0.61, 0.76, 0.74],"payload":{"city":"Berlin"}},
  {"id":2,"vector":[0.19, 0.81, 0.75, 0.11],"payload":{"city":"London"}},
  {"id":3,"vector":[0.36, 0.55, 0.47, 0.94],"payload":{"city":"Moscow"}},
  {"id":4,"vector":[0.18, 0.01, 0.85, 0.80],"payload":{"city":"New York"}},
  {"id":5,"vector":[0.24, 0.18, 0.22, 0.44],"payload":{"city":"Beijing"}},
  {"id":6,"vector":[0.35, 0.08, 0.11, 0.44],"payload":{"city":"Mumbai"}}
]}' \
-H  "${API_KEY_HEADER}" \
$QDRANT_URL/collections/${QDRANT_COLLECTION}/points --fail-with-body

# Run query
curl -X POST \
-H 'Content-Type: application-json' \
-d '{"vector":[0.2, 0.1, 0.9, 0.7],"limit":3}' \
-H  "${API_KEY_HEADER}" \
$QDRANT_URL/collections/${QDRANT_COLLECTION}/points/search --fail-with-body
