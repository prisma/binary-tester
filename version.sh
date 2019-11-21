#!/bin/bash

# test.sh tests a given image by launching the docker build --no-cache and run process with full log output

set -eux

docker build . --no-cache -f version.dockerfile --build-arg IMAGE="$i"
