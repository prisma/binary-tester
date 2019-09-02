#!/bin/bash

# spawn.sh launches an instance of a given file, saves logs and outputs success or fail

log="logs/$(echo $i | tr '/' '-').txt"

start=$(date +%s.%N)

set +e
make i=$i test > $log 2>&1
ret=$?
set -e

end=$(date +%s.%N)
diff=$(LC_NUMERIC="en_US.UTF-8" printf '%.*fs' 1 $(echo "$end - $start" | bc))

if [ $ret -eq 0 ]; then
  echo "$i $name $(tput setaf 2)success$(tput sgr0) $diff"
else
  echo "$i $name $(tput setaf 1)fail$(tput sgr0) $diff; please see file://$(pwd)/$log for details"
fi
