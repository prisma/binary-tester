ARG IMAGE
FROM $IMAGE

# TODO somehow node is supposed to installed in this image but it's not
# for now, just manually install nodejs instead

USER root
RUN apt-get -qq update > /dev/null
RUN apt-get -qq install -y curl > /dev/null
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get -qq install -y nodejs > /dev/null
