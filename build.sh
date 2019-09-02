#!/bin/bash

# build.sh builds the rust binary from source to see if building on this image automatically fixes the issue

set -eu

build_image=$build
run_image=${run:-$build}

# get base image, e.g. netlify/build:xenial -> netlify/build
build_base_image=$(echo $build_image | cut -d: -f1)
run_base_image=$(echo $run_image | cut -d: -f1)

# use - instead of / to prevent interpretation of folders
build_image_name=$(echo $build | tr '/' '_')
run_image_name=$(echo $run_image | tr '/' '_')

temp_build_image_name="base_build_$build_image"
temp_run_image_name="base_run_$run_image"

# 1. build <image>.build.dockerfile to set up build dependencies.
if test -f "platforms/$build_image_name.build.dockerfile"; then
  echo "[build] using specific dockerfile platforms/$build_image_name.build.dockerfile"
  docker build -f platforms/$build_image_name.build.dockerfile --build-arg IMAGE=$build_image -t $temp_build_image_name .
elif test -f "platforms/$build_base_image.build.dockerfile"; then
  echo "[build] using base dockerfile platforms/$build_base_image.build.dockerfile for $build_image"
  docker build -f platforms/$build_base_image.build.dockerfile --build-arg IMAGE=$build_image -t $temp_build_image_name .
else
  echo "[build] no custom dockerfile found. note that this often results in errors because dependencies such as node is missing."
  echo "[build] if you want to customize steps, please create platforms/$build_base_image.build.dockerfile or platforms/$build_image.build.dockerfile."
  temp_build_image_name="$build_image"
fi

# 2. build the platform base image where the binary should run
if test -f "platforms/$run_image_name.run.dockerfile"; then
  echo "[run] using specific dockerfile platforms/$run_image_name.run.dockerfile"
  docker build -f platforms/$run_image_name.run.dockerfile --build-arg IMAGE=$run_image -t $temp_run_image_name .
elif test -f "platforms/$run_base_image.run.dockerfile"; then
  echo "[run] using base dockerfile platforms/$run_base_image.run.dockerfile for $run_image"
  docker build -f platforms/$run_base_image.run.dockerfile --build-arg IMAGE=$run_image -t $temp_run_image_name .
else
  echo "[run] no custom dockerfile found. note that this often results in errors because dependencies such as node is missing."
  echo "[run] if you want to customize steps, please create platforms/$run_base_image.run.dockerfile or platforms/$run_image.run.dockerfile."
  temp_run_image_name="$build_image"
fi

# cut out the dot so we can tag correctly
build_tag_name=$(echo $build_image_name | tr ':' '_')
run_tag_name=$(echo $run_image_name | tr ':' '_')

# 3. build the binary and set up the run image
docker build . -f build.dockerfile \
  --build-arg IMAGE_BUILD=$temp_build_image_name \
  --build-arg IMAGE_RUN=base_run_$run_image \
  -t test_$build_tag_name-on-$run_tag_name

# 4. run the binary tests
docker run test_$build_tag_name-on-$run_tag_name
