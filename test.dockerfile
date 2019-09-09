ARG IMAGE_FETCH
ARG IMAGE_RUN

# using a builder step just so we don't have to run npm i later; this may already prevent some bugs
FROM node as builder

ARG FETCH_ENGINE_VERSION=latest

WORKDIR /app

RUN node -v
RUN npm -v

RUN echo "build machine information:" && \
  lsb_release -a || true && \
  uname -a || true && \
  ls /lib/x86_64-linux-gnu | grep libssl || true && \
  openssl version || true

RUN npm i @prisma/fetch-engine@$FETCH_ENGINE_VERSION

COPY fetch.js schema.prisma ./

# start the real image and fetch the script
FROM $IMAGE_FETCH as fetcher

WORKDIR /app

COPY --from=builder /app /app

COPY test-fetch.sh ./

RUN sh test-fetch.sh

# copy the binary over annd run the real script
FROM $IMAGE_RUN

WORKDIR /app

COPY --from=fetcher /app /app

COPY test-run.sh ./

CMD sh test-run.sh
