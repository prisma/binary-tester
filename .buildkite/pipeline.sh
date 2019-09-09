#!/bin/bash

make -s all-buildkite | buildkite-agent pipeline upload
