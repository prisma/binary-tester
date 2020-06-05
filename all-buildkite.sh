#!/bin/bash

# all-buildkite.sh tests all specified images at once on buildkite

set -eu

cmd=""

# raw test first
while read -r item; do
  i=$(echo $item | cut -d# -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  note=$(echo $item | cut -d# -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  if [ "$i" = "" ]; then
    continue
  fi

  if [ "$note" = "" ]; then
    note="$i"
  fi

  cmd="$cmd
  - label: '(direct) $note'
    command: make i='$i' raw-test
    soft_fail: false"
done <images.txt

cmd="$cmd
  - wait"

# run full tests with fetch-engine
while read -r item; do
  i=$(echo $item | cut -d# -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  note=$(echo $item | cut -d# -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  if [ "$i" = "" ]; then
    continue
  fi

  if [ "$note" = "" ]; then
    note="$i"
  fi

  cmd="$cmd
  - label: '(full) $note'
    command: make i='$i' test
    soft_fail: false"
done <images.txt

echo "steps: $cmd"
