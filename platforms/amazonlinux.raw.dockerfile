ARG IMAGE
FROM $IMAGE

RUN yum install -y gzip gunzip

ENV URL=https://prisma-builds.s3-eu-west-1.amazonaws.com/master/latest/rhel-openssl-1.0.x/prisma.gz
