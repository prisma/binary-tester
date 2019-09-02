ARG IMAGE
FROM $IMAGE

USER root

RUN yum -qy install openssl
