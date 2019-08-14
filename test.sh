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

# this will fail because of an invalid migration
# we just check if it's this exact error (migaration failed) or a fatal one (e.g. libssl.so.10 not found)
expected='{"jsonrpc":"2.0","error":{"code":-32600,"message":"Invalid request"},"id":null}'

# test migration-engine
actual=$(echo "{}" | ./migration-engine)

# some weird-ass sh variable comparison
if [ "$actual" != "$expected" ]; then
  echo "migration-engine failed with error $actual"
  echo "fail"
  exit 1
fi

echo "migration-engine succeeded"
echo "success"
