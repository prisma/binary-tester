#!/bin/bash

# buildall.sh builds binaries on all given systems

set -eu

images=( "ubuntu:14.04" "ubuntu:16.04" "ubuntu:18.04" )
#images=( "debian:7" "debian:8" "debian:9" )
#images=( "ubuntu:14.04" "ubuntu:14.10" "ubuntu:16.04" "ubuntu:16.10" "ubuntu:18.04" "ubuntu:18.10" )

mkdir -p logs/

for i in "${images[@]}"
do
#  for j in "${images[@]}"
#  do
j=$i
    log="logs/$(echo $i | tr '/' '-')_$(echo $j | tr '/' '-').build.txt"

    start=$(date +%s.%N)

    set +e
    make build=$i run=$j build > $log 2>&1
    ret=$?
    set -e

    end=$(date +%s.%N)
    diff=$(printf '%.*fs' 1 $(echo "$end - $start" | bc))

    if [ $ret -eq 0 ]; then
      echo "$i->$j $(tput setaf 2)success$(tput sgr0) $diff"
    else
      echo "$i->$j $(tput setaf 1)fail$(tput sgr0) $diff; please see file://$(pwd)/$log for details"
    fi
#  done
done

echo "done"
