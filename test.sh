#!/bin/bash

# test.sh tests a given image by launching the docker build and run process with full log output

set -eux

name=$(echo $i | tr '/' '_')
# split by colon to get the base image
base_image=$(echo $name | cut -d: -f1)

temp_run_image_name="base_$i"

if test -f "platforms/$name.test.dockerfile"; then
  echo "using specific dockerfile platforms/$name.test.dockerfile"
  docker build -f platforms/$name.test.dockerfile --build-arg IMAGE=$i -t $temp_run_image_name .
elif test -f "platforms/$base_image.test.dockerfile"; then
  echo "using base dockerfile platforms/$base_image.test.dockerfile for $i"
  docker build -f platforms/$base_image.test.dockerfile --build-arg IMAGE=$i -t $temp_run_image_name .
else
  echo "no custom dockerfile found. note that this often results in errors because dependencies such as node is missing."
  echo "if you want to customize steps, please create platforms/$base_image.test.dockerfile or platforms/$name.test.dockerfile."
  temp_run_image_name="$i"
fi

docker build -f test.dockerfile --build-arg IMAGE=$temp_run_image_name -t test_$name .

docker run test_$name
