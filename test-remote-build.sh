#!/bin/bash

json="{\"parameter\": [{\"name\": \"name\", \"value\": \"adam\"}], \"\": \"\"}"
url=http://sth016ux:8080/job/cq-triggered-build/build

curl -X POST $url -d token=nisse --data-urlencode json="$json"

# Example from MovingMedia Android build trigger
curl "http://tokyo.local:8080/job/android-build-release/buildWithParameters?token=GERONIMO&asseturl=http://10.36.102.40/~jendeberg/brand-new-build.tar"
