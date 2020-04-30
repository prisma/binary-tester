ARG IMAGE
FROM $IMAGE

RUN apk update > /dev/null 
RUN apk add nodejs npm && rm -rf /var/cache/apk/*
# RUN npm i -g n
# RUN n latest
RUN node
