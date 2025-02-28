#!/bin/sh

BASEURL="https://cdn.jsdelivr.net/npm/apache-arrow"

# get (latest) dep
# see https://stackoverflow.com/a/38795701/2555983 for --backups
# basically keeps the last one as backup but
wget --backups=1 ${BASEURL}/Arrow.es2015.min.js
rm *.js.1

# get (latest) version
curl -s ${BASEURL}'/package.json' | jq -r '.version' > version.txt
