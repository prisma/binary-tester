#!/bin/bash

set -eux

# ldd outputs all required libraries, including missing ones for debugging
ldd ./query-engine

# test query-engine
export PRISMA_DML="$(cat schema.prisma)"
./query-engine cli --dmmf > /dev/null

echo "query-engine succeeded"

echo "success"
