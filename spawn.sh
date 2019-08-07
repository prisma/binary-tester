#!/bin/bash

# spawn.sh launches an instance of a given file, saves logs and outputs success or fail

log="logs/$(echo $i | tr '/' '-').txt"

set +e
make i=$i run > $log 2>&1

if [ $? -eq 0 ]; then
  echo "$i $(tput setaf 2)success$(tput sgr0)"
else
  echo "$i $(tput setaf 1)fail$(tput sgr0); please see file://$(pwd)/$log for details"
fi
