#!/bin/bash

set -eux

# ldd outputs all required libraries, including missing ones for debugging
ldd ./query-engine

# test query-engine
./query-engine --version

echo "query-engine succeeded"

echo "success"
