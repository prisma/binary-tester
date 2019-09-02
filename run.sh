#!/bin/bash

# run.sh tests a given image by launching the docker build and run process with full log output

set -eux

name=$(echo $i | tr '/' '-')
# split by colon to get the base image
base_image=$(echo $i | cut -d: -f1)

run_image_name="base_$base_image"

if test -f "platforms/$name.dockerfile"; then
  echo "using specific dockerfile $name"
  docker build -f platforms/$name.dockerfile --build-arg IMAGE=$i -t run_image_name .
elif test -f "platforms/$base_image.dockerfile"; then
  echo "using base dockerfile $base_image for $i"
  docker build -f platforms/$base_image.dockerfile --build-arg IMAGE=$i -t run_image_name .
else
  echo "no custom dockerfile found. note that this often results in errors because dependencies such as node is missing."
  base_image="$base_image"
fi

docker build -f main.dockerfile --build-arg IMAGE=run_image_name -t test_$name .

docker run test_$name
