ARG IMAGE
FROM $IMAGE

RUN yum install -y gzip gunzip

ENV URL=https://s3-eu-west-1.amazonaws.com/prisma-native/master/latest/linux-glibc-libssl1.0.1/prisma.gz
