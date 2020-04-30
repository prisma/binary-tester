ARG IMAGE
FROM $IMAGE

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update > /dev/null
RUN apt-get -qq install -y --no-install-recommends apt-utils > /dev/nul
RUN apt-get -qq install -y nodejs npm curl > /dev/null
RUN npm i -g n
RUN n latest
RUN node -v
