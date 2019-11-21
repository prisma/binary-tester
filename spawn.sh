#!/bin/bash

# spawn.sh launches an instance of a given file, saves logs and outputs success or fail
# this is invoked by batch tests

cmd="$1"
i="$2"
name="$3"

log="logs/$cmd/$(echo "$i" | tr '/' '_').txt"

mkdir -p "logs/$cmd"

start=$(date "+%s")

set +e
make i="$i" "$cmd" > $log 2>&1
ret=$?
set -e

end=$(date "+%s")
diff="$(echo "$end - $start" | bc)s"

if [ $ret -eq 0 ]; then
  echo "$i $name $(tput setaf 2)success$(tput sgr0) $diff"
else
  echo "$i $name $(tput setaf 1)fail$(tput sgr0) $diff; please see $log for details"
fi
