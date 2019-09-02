ARG IMAGE
FROM $IMAGE

RUN apt-get -qq update > /dev/null
RUN apt-get -qq install libssl1.0.0 > /dev/null
