#!/bin/bash

# build.sh builds the rust binary from source to see if building on this image automatically fixes the issue

set -eux

build_image=$build
run_image=${run:-$build}

# use - instead of / just for platforms
build_image_name=$(echo $build | tr '/' '-')
run_image_name=$(echo $run_image | tr '/' '-')

# 1. build <image>.build.dockerfile to set up build dependencies.
docker build -f platforms/$build_image_name.build.dockerfile --build-arg IMAGE=$build_image -t pre_$build_image .

# 2.1 build platform base image where the binary should be `BUILT`, which is required for both build script but also the normal run script (mainly to install nodejs)
docker build -f platforms/$build_image_name.dockerfile --build-arg IMAGE=pre_$build_image -t base_$build_image .
# 2.2 build the platform base image  where the binary should be `RUN`
docker build -f platforms/$run_image_name.dockerfile --build-arg IMAGE=$run_image -t base_$run_image .

# 3. build the binary and set up the run image
docker build -f build.dockerfile --build-arg IMAGE=base_$build_image --build-arg IMAGE_TARGET=base_$run_image -t test_$build_image .

# 4. run the binary tests
docker run test_$build_image
