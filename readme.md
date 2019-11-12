# binary-tester [![Build status](https://badge.buildkite.com/b0b8963f54169ad79cee4da30dd9c1c9d2da97caafe92a3054.svg)](https://buildkite.com/prisma/binary-testing?branch=master)

binary-tester helps testing the prisma rust binaries on various platforms. Test
more platforms with a single command and debug failing platforms more easily.

While this could be fully automated in the future, at this time everything is [tracked manually on Notion](https://www.notion.so/prismaio/Platform-support-dd6b96774c3e4f37ac3661382d4b5849).

## Basic usage

Test whether photonjs, or more precisely the binary and the binary fetching process,
runs on a given platform. For example, to test on the docker image `node`:

```
$ make i=node test
[...]
[...]
[...]
./query-engine cli --dmmf
query-engine succeeded
migration-engine succeeded
success
```

## Just test the binaries

```
$ make i=node test-raw
[...]
[...]
success
```

## Testing multiple platforms

There's a `./all.txt` containing a docker tag per line to specify which platforms 
to test on:

```
node
node:12
node:alpine
[...]
```

Run the following command to see the platform support at a glance:

*NOTE*: Running this will download various images which can take 10s of GBs. Use with caution,
or better yet, run on a temporary remote server.

```
$ make all
node success 1.6s
node:12 success 1.6s
node:alpine fail 2.0s; please see logs/node:alpine.txt for details
ubuntu:16.04 success 2.2s
ubuntu:18.04 success 2.0s
[...]
```

To just rest the raw binaries:

```
$ make raw-all
node success 1.6s
node:12 success 1.6s
node:alpine fail 2.0s; please see logs/node:alpine.txt for details
ubuntu:16.04 success 2.2s
ubuntu:18.04 success 2.0s
[...]
```

If you want to add more platforms, just add it to `./all.txt` and optionally add a comment:

```
debian:10 # Debian Buster
```

Then, just run `make all` again.

## If a platform fails

When a platform succeeds – awesome. When it doesn't, the fun part starts.
This script can help with debugging, though.

For example, by default, the Ubuntu 16.04 image will fail. This is because we don't have 
NodeJS installed (photon needs that, obviously) and because Ubuntu doesn't ship with 
OpenSSL per default, which means the user will have to install those.

```
ubuntu:16.04 fail 2.5s; please see logs/ubuntu:16.04.txt
```

To try "fixing" it, we can create a custom dockerfile for ubuntu and add steps until it works.

We have two options:

1) Create a `platforms/ubuntu.test.dockerfile` which will run on any ubuntu image, 
regardless of the tag. It should look like this:

```dockerfile
ARG IMAGE
FROM $IMAGE
```

We just need to install NodeJS now (which will also install OpenSSL for us!):

```dockerfile
ARG IMAGE
FROM $IMAGE

RUN apt-get -qq update > /dev/null
RUN apt-get -qq install -y nodejs npm curl > /dev/null
RUN npm i -g n
RUN n latest
RUN node -v
```

2) Create a image & tag-specific `platforms/ubuntu:16.04.test.dockerfile` which will 
run only for the image & tag `ubuntu:16.04`.

*NOTE:* When using an image which contains a slash, like `netlify/build:xenial`, you have to 
use an underscore in the dockerfile, e.g. `platforms/netlify_build:xenial.test.dockerfile`. 

When running any of the above testing commands, we will see that the script will pick 
up either of the dockerfiles and succeed:

```
$ make i=ubuntu:16.04 test
[...]
using base dockerfile platforms/ubuntu.test.dockerfile for ubuntu:16.04
[...]
success
```

## Further steps

*ATTENTION: EXPERIMENTAL!*

There's a chance that the currently built binaries won't ever work on a given platform.
This script can help to debug if a binary works when it's compiled on the same or a given platform.

For example, let's pretend that Ubuntu 16.04 doesn't work, and we can't fix it by installing 
dependencies. Let's build the rust binary on ubuntu:16.04 and see if it can run on a different 
fresh Ubuntu instance out of the box:

```
$ make build=ubuntu:16.04 build
```

Doesn't work, because we obviously need rust dependencies, so let's add them (again, using platform
dockerfiles as above) by creating `platforms/ubuntu.build.dockerfile` (note the ".build"):

```dockerfile
ARG IMAGE
FROM $IMAGE

RUN apt-get -qq update > /dev/null
RUN apt-get -qq install -y curl git libssl-dev pkg-config > /dev/null
```

Currently, the rust init script is used, which means we just have to install curl,
git, libssl and other platform-dependent tools.

Let's run `make build=ubuntu:16.04 build` again and we'll see that rust successfully 
compiles the binary, but does not yet run on the Ubuntu image because libssl is missing.
To fix the run step, create `platforms/ubuntu.run.dockerfile` (note the ".run"):

```dockerfile
ARG IMAGE
FROM $IMAGE

RUN apt-get -qq update > /dev/null
RUN apt-get -qq install openssl > /dev/null
```

And now...

```
$ make build=ubuntu:16.04 build
[...]
success
```

### Building and running on a different platforms

It's also easy to try building on one platform, while testing the binary on another.
For example, let's try building on Debian and running on Ubuntu:

```
$ make build=debian:8 run=ubuntu:16.04 build
[...]
success
```

If you need to adapt some steps of either the build or the run image, just create
the respective dockerfile.

# Caveats and notes

- The test script/dockerfile needs nodejs to run the actual tests. Running the binary works 
out of the box because nodejs depends on openssl, installing it automatically. This is great
for NodeJS/PhotonJS users because they don't need to install OpenSSL separately. However, this
may lead to confusion and is probably not future proof (Photon for other languages need different 
solutions).
