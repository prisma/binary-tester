.PHONY: spawn run build buildall all

# spawn test, output logs to log file and only log success or fail to stdout
spawn:
	bash spawn.sh $(i)

# run a test and log everything to stdout
run:
	bash run.sh $(i)

buildall:
	bash buildall.sh $(i)

# run a test and log everything to stdout
build:
	bash build.sh $(build) $(run)

# run all tests, save outputs to log files and show success/fail
all:
	bash all.sh
