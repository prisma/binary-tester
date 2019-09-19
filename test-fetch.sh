#!/bin/bash

set -eux

node -v
npm -v

cat /etc/lsb-release || true
lsb_release -a || true
uname -v || true
openssl version || true

rm query-engine || true

DEBUG="*" node fetch.js

ls

mv query-engine* query-engine

echo "fetching binaries was successful"
