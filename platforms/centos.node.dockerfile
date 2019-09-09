ARG IMAGE
FROM $IMAGE

USER root

RUN yum -qy install wget
RUN wget http://nodejs.org/dist/v0.10.30/node-v0.10.30-linux-x64.tar.gz
RUN tar --strip-components 1 -xzvf node-v* -C /usr/local
RUN npm i -g n
RUN n latest
RUN node -v
