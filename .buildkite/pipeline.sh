#!/bin/bash

printf "
steps:
    - label: Test :llama:
      command: echo 'test'
" | buildkite-agent upload