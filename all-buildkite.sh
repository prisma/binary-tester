#!/bin/bash

# all-buildkite.sh tests all specified images at once on buildkite

set -eu

cmd=""

while read item; do
  i=$(echo $item | cut -d# -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  note=$(echo $item | cut -d# -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  if [ "$i" = "" ]; then
    continue
  fi

  if [ "$note" = "" ]; then
    note="$i"
  fi

  cmd="$cmd
  - label: '$note'
    command: make i='$i' test
    soft_fail: true"
done <all.txt

echo "steps: $cmd"
