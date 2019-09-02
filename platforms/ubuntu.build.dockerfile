ARG IMAGE
FROM $IMAGE

RUN apt-get -qq update > /dev/null
RUN apt-get -qq install -y curl git libssl-dev pkg-config > /dev/null
