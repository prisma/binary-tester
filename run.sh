#!/bin/bash

# run.sh tests a given image by launching the docker build and run process with full log output

set -eux

name=$(echo $i | tr '/' '-')

docker build -f platforms/$name.dockerfile --build-arg IMAGE=$i -t base_$name .

docker build -f main.dockerfile --build-arg IMAGE=$name -t test_$name .

docker run test_$name
