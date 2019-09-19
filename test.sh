#!/bin/bash

# test.sh tests a given image by launching the docker build --no-cache and run process with full log output

set -eux

# shellcheck disable=SC2154
name=$(echo "$i" | tr '/' '_')
# split by colon to get the base image
base_image=$(echo "$name" | cut -d: -f1)

temp_fetch_image_name="base_$i"
temp_run_image_name="test_run_$i"

# prepare test scripts
if test -f "platforms/$name.node.dockerfile"; then
  echo "using specific dockerfile platforms/$name.node.dockerfile"
  docker build --no-cache -f "platforms/$name.node.dockerfile" --build-arg IMAGE="$i" -t "$temp_fetch_image_name" .
elif test -f "platforms/$base_image.node.dockerfile"; then
  echo "using base dockerfile platforms/$base_image.node.dockerfile for $i"
  docker build --no-cache -f "platforms/$base_image.node.dockerfile" --build-arg IMAGE="$i" -t "$temp_fetch_image_name" .
else
  echo "no custom dockerfile found. note that this often results in errors because dependencies such as node is missing."
  echo "if you want to customize steps, please create platforms/$base_image.node.dockerfile or platforms/$name.node.dockerfile."
  temp_fetch_image_name="$i"
fi

# prepare run scripts
if test -f "platforms/$name.run.dockerfile"; then
  echo "using specific dockerfile platforms/$name.run.dockerfile"
  docker build --no-cache -f "platforms/$name.run.dockerfile" --build-arg IMAGE="$i" -t "$temp_run_image_name" .
elif test -f "platforms/$base_image.run.dockerfile"; then
  echo "using base dockerfile platforms/$base_image.run.dockerfile for $i"
  docker build --no-cache -f "platforms/$base_image.run.dockerfile" --build-arg IMAGE="$i" -t "$temp_run_image_name" .
else
  echo "no custom dockerfile found. note that this often results in errors because dependencies such as node is missing."
  echo "if you want to customize steps, please create platforms/$base_image.run.dockerfile or platforms/$name.run.dockerfile."
  temp_run_image_name="$i"
fi

docker build --no-cache -f test.dockerfile . \
  --build-arg IMAGE_FETCH="$temp_fetch_image_name" \
  --build-arg IMAGE_RUN="$temp_run_image_name"
