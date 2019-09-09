ARG IMAGE
FROM $IMAGE

RUN apt-get -qq update > /dev/null
RUN apt-get -qq install -y nodejs npm curl > /dev/null
# ubuntu 14.04 needs the following line
RUN npm config set strict-ssl false
RUN npm i -g n
RUN n latest
RUN node -v
