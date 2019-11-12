#!/bin/bash

# all.sh tests all specified images at once

set -eu

cmd="$1"

mkdir -p logs/

while read item; do
  img=$(echo $item | cut -d# -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  note=$(echo $item | cut -d# -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  if [ "$img" = "" ]; then
    echo ""
    continue
  fi

  if [ "$img" = "$note" ]; then
    note=""
  else
    note="($note)"
  fi

  # add/remove an ampersand at the end of the next command to execute serially/in parallel
  sh spawn.sh "$cmd" "$img" "$note" # &
done <images.txt

# wait if run in parallel
wait

echo "done"
