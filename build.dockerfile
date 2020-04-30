ARG IMAGE_BUILD
ARG IMAGE_RUN=$IMAGE_BUILD

# binary build step
FROM $IMAGE_BUILD as build

WORKDIR /app

# install rust, supply -y to install because docker is non-interactive
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN ~/.cargo/bin/cargo --version

RUN git clone https://github.com/prisma/prisma-engine.git
RUN cd prisma-engine && ~/.cargo/bin/cargo build --release

RUN echo "BUILD: " && cat /etc/lsb-release || true
RUN echo "BUILD: " && lsb_release -a || true
RUN echo "BUILD: " && uname -v || true
RUN echo "BUILD: " && ls -R /lib | grep ssl || true
RUN echo "BUILD: " && ls -R /usr/lib | grep ssl || true
RUN echo "BUILD: " && openssl version || true

# run on a given image step
FROM $IMAGE_RUN

WORKDIR /app

RUN echo "RUN: " && cat /etc/lsb-release || true
RUN echo "RUN: " && lsb_release -a || true
RUN echo "RUN: " && uname -v || true
RUN echo "RUN: " && ls -R /lib | grep ssl || true
RUN echo "RUN: " && ls -R /usr/lib | grep ssl || true
RUN echo "RUN: " && openssl version || true

COPY --from=build /app/prisma-engine/target/release/prisma .

RUN ./prisma --version && echo "success"
