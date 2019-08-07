ARG IMAGE

# using a builder step just so we don't have to run npm i later; this may already prevent some bugs
FROM node as builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN echo "using the following versions to build project"
RUN node -v
RUN npm -v

RUN npm i

COPY fetch.js schema.prisma ./

# start the real image and run the test script
FROM $IMAGE

WORKDIR /app

COPY --from=builder /app /app

COPY test.sh ./

ENV FETCH_ENGINE_VERSION=latest

CMD sh test.sh
