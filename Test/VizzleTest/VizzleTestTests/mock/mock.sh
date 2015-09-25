#!/bin/sh

curl -H 'Content-Type: application/json' \
     -X POST http://42.121.16.186:9999/baseservice/getRecommendList \
     -d '{"country": "TW","start":"0","size":"10"}'
