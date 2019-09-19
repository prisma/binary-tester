ARG IMAGE_FETCH
ARG IMAGE_RUN

FROM $IMAGE_FETCH as fetch

WORKDIR /app

ADD $URL ./query-engine.gz

RUN ls -lah

RUN gunzip query-engine.gz

RUN ls -lah

RUN chmod +x query-engine

FROM $IMAGE_RUN

WORKDIR /app

COPY --from=fetch /app/query-engine .

RUN ./query-engine --help
