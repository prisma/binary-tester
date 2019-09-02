.PHONY: spawn run build buildall all

# spawn test, output logs to log file and only log success or fail to stdout
test-spawn:
	bash test-spawn.sh $(i)

# test and log everything to stdout
test:
	bash test.sh $(i)

buildall:
	bash buildall.sh

# build binary and run on given images
build:
	bash build.sh $(build) $(run)

# run all tests, save outputs to log files and show success/fail
all:
	bash all.sh
