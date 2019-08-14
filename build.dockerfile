ARG IMAGE
ARG IMAGE_TARGET=$IMAGE

# start the real image and run the test script
FROM $IMAGE as build

# TODO temp, use master
ARG PRISMA_HEAD=af2156a0d0bad794a6d305b3856976702171a9ba

WORKDIR /app

# install rust, supply -y to install because docker is non-interactive
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN ~/.cargo/bin/cargo --version

RUN git clone https://github.com/prisma/prisma.git
RUN cd prisma && git checkout $PRISMA_HEAD
RUN cd prisma/server/prisma-rs && ~/.cargo/bin/cargo build --release

RUN echo "build machine information:" && \
  cat /etc/lsb-release || true && \
  lsb_release -a || true && \
  uname -v || true && \
  ls /lib/x86_64-linux-gnu | grep libssl || true && \
  openssl version || true

FROM $IMAGE_TARGET

WORKDIR /app

RUN echo "run machine information:" && \
  cat /etc/lsb-release || true && \
  lsb_release -a || true && \
  uname -v || true && \
  ls /lib/x86_64-linux-gnu | grep libssl || true && \
  openssl version || true

COPY --from=build /app/prisma/server/prisma-rs/target/release/prisma .

COPY schema.prisma .

CMD export PRISMA_DML="$(cat schema.prisma)" && \
  ./prisma cli --dmmf > /dev/null && \
  echo "success"
