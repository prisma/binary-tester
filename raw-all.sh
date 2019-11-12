#!/bin/bash

# raw-all.sh tests all specified images at once

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

  make -s i="$i" name="$note" $cmd
done <images.txt

echo "done"
