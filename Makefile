.PHONY: test raw-test build all raw-all buildall all-buildkite

# test and log everything to stdout
test:
	bash test.sh

# test a single binaries
raw-test:
	bash raw-test.sh

### build scripts for manual binary compilation testing

# build binary and run on given images
build:
	bash build.sh $(build) $(run)

### batch pipelines
### saves outputs to log files and show success/fail

# run all tests
all:
	bash all.sh test

# run all raw tests (test just the binaries)
raw-all:
	bash all.sh raw-test

buildall:
	bash buildall.sh

### CI

# run all tests on buildkite
all-buildkite:
	bash all-buildkite.sh
