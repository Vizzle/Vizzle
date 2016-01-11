#!/bin/sh

curl -H 'Content-Type: application/json' \
     -X POST http://api.cuitrip.com/baseservice/serviceSearch \
     -d '{"KeyWord": "历史","sort":"service_default_rank","start":"0","size":"10"}'
