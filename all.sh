#!/bin/bash

# all.sh tests all specified images at once

set -eu

mkdir -p logs/

while read item; do
  i=$(echo $item | cut -d# -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  note=$(echo $item | cut -d# -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  if [ "$i" = "" ]; then
    echo ""
    continue
  fi

  if [ "$i" = "$note" ]; then
    note=""
  else
    note="($note)"
  fi

  # add/remove an ampersand at the end of the next command to execute serially/in parallel
  make -s i="$i" name="$note" spawn # &
done <all.txt

# wait if run in parallel
wait

echo "done"
