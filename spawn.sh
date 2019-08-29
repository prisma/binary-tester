#!/bin/bash

# spawn.sh launches an instance of a given file, saves logs and outputs success or fail

log="logs/$(echo $i | tr '/' '-').txt"

start=$(date +%s.%N)

set +e
make i=$i run > $log 2>&1
ret=$?
set -e

end=$(date +%s.%N)
diff=$(printf '%.*fs' 1 $(echo "$end - $start" | bc))

if [ $ret -eq 0 ]; then
  echo "$i $(tput setaf 2)success$(tput sgr0) $diff"
else
  echo "$i $(tput setaf 1)fail$(tput sgr0) $diff; please see file://$(pwd)/$log for details"
fi
