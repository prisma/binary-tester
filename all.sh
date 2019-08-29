#!/bin/bash

# all.sh tests all specified images at once

set -eu

images=( "node" "node:12" "node:10" "node:8" "node:6" "node:alpine" "debian:9" "debian:8" "centos:7" "ubuntu:14.04" "ubuntu:16.04" "ubuntu:18.04" "ubuntu:14.10" "ubuntu:16.10" "ubuntu:18.10" )

mkdir -p logs/

for i in "${images[@]}"
do
  # add/remove an ampersand at the end of the next command to execute serially/in parallel
  make -s i=$i spawn # &
done

# wait if run in parallel
wait

echo "done"
