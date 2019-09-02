ARG IMAGE
FROM $IMAGE

RUN apt-get -qq update > /dev/null
RUN apt-get -qq install -y build-essential curl git libssl-dev pkg-config > /dev/null
