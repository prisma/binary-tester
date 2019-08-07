#!/bin/bash

# all.sh tests all specified images at once

set -eu

images=( "node" "node:alpine" "debian:stretch" "centos:7" "ubuntu:16.04" )

mkdir -p logs/

for i in "${images[@]}"
do
  # add/remove an ampersand at the end of the next command to execute serially/in parallel
  make -s i=$i spawn &
done

# wait if run in parallel
wait

echo "done"
