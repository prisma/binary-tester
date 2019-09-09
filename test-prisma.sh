#!/bin/bash

set -eux

node -v
npm -v

cat /etc/lsb-release || true
lsb_release -a || true
uname -v || true
openssl version || true

rm migration-engine 2< /dev/null || true
rm query-engine 2< /dev/null || true

DEBUG=* node fetch.js

echo "fetching binaries was successful"

ls

mv query-engine* query-engine

# ldd outputs all required libraries, including missing ones for debugging
ldd ./query-engine
ldd ./migration-engine

# test query-engine
export PRISMA_DML="$(cat schema.prisma)"
./query-engine cli --dmmf > /dev/null

echo "query-engine succeeded"

echo "success"
