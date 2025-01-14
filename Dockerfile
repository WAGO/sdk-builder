ARG REGISTRY_PREFIX=''
ARG CODENAME='focal'


FROM ${REGISTRY_PREFIX}ubuntu:${CODENAME} as builder
COPY certs/* /usr/local/share/ca-certificates/
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive TZ="Europe/Berlin" apt install -y --no-install-recommends \
        build-essential \
        curl \
        libncurses5-dev \
        libncurses5w-dev \
        wget \
        gawk \
        flex \
        bison \
        texinfo \
        python-dev \
        python3-setuptools \
        g++ \
        dialog \
        lzop \
        libc6-dev \
        autoconf \
        libtool \
        xmlstarlet \
        xsltproc \
        doxygen \
        autopoint \
        gettext \
        rsync \
        vim \
        software-properties-common \
        bc \
        groff \
        zip \
        unzip \
        pkg-config

FROM builder as dumb_init
ARG BUILD_DIR=/tmp/build
ARG DUMB_INIT_VERSION=1.2.5
RUN mkdir -p "${BUILD_DIR}" \
  && cd "${BUILD_DIR}" \
  && curl -fSL -s -o dumb-init-${DUMB_INIT_VERSION}.tar.gz https://github.com/Yelp/dumb-init/archive/v${DUMB_INIT_VERSION}.tar.gz \
  && tar -xf dumb-init-${DUMB_INIT_VERSION}.tar.gz \
  && cd "dumb-init-${DUMB_INIT_VERSION}" \
  && make \
  && chmod +x dumb-init \
  && mv dumb-init /usr/local/bin/dumb-init \
  && dumb-init --version

FROM builder as toolchain
ARG TOOLCHAIN_DIR=/opt/gcc-Toolchain-2022.08-wago.1
ARG TOOLCHAIN_URL_ARM32=https://github.com/WAGO/gcc-toolchain/releases/download/gcc-toolchain-2022.08-wago.1/gcc-linaro.toolchain-2022.08-wago.1-arm-linux-gnueabihf.tar.gz
ARG TOOLCHAIN_URL_AARCH64=https://github.com/WAGO/gcc-toolchain/releases/download/gcc-toolchain-2022.08-wago.1/gcc-linaro.toolchain-2022.08-wago.1-aarch64-linux-gnu.tar.gz
RUN mkdir -p "${TOOLCHAIN_DIR}" \
  && curl -fSL -s -o gcc-linaro.toolchain-2022.08-wago.1-arm-linux-gnueabihf.tar.gz "${TOOLCHAIN_URL_ARM32}" \
  && tar -xf gcc-linaro.toolchain-2022.08-wago.1-arm-linux-gnueabihf.tar.gz -C "${TOOLCHAIN_DIR}" \
  && rm -rf "${TOOLCHAIN_DIR}/.git" \
    "${TOOLCHAIN_DIR}/arm-linux-gnueabihf/share/doc" \
    gcc-linaro.toolchain-2022.08-wago.1-arm-linux-gnueabihf.tar.gz \
  && curl -fSL -s -o gcc-linaro.toolchain-2022.08-wago.1-aarch64-linux-gnu.tar.gz "${TOOLCHAIN_URL_AARCH64}" \
  && tar -xf gcc-linaro.toolchain-2022.08-wago.1-aarch64-linux-gnu.tar.gz -C "${TOOLCHAIN_DIR}" \
  && rm -rf "${TOOLCHAIN_DIR}/.git" \
    "${TOOLCHAIN_DIR}/aarch64-linux-gnu/share/doc" \
    gcc-linaro.toolchain-2022.08-wago.1-aarch64-linux-gnu.tar.gz

FROM builder as ptxdist
ARG PTXDIST_URL=https://github.com/WAGO/ptxdist/archive/refs/tags/Update-2020.08.0.tar.gz
RUN cd /tmp \
  && curl -fSL -s -o ptxdist.tar.xz "${PTXDIST_URL}" \
  && tar -xf ptxdist.tar.xz \
  && cd ptxdist-Update-2020.08.0 \
  && ./configure \
  && make

FROM builder as image

ARG TOOLCHAIN_DIR=/opt/gcc-Toolchain-2022.08-wago.1

COPY --from=dumb_init /usr/local/bin/dumb-init /usr/local/bin/dumb-init
COPY --from=toolchain "${TOOLCHAIN_DIR}" "${TOOLCHAIN_DIR}"

COPY --from=ptxdist /tmp/ptxdist-Update-2020.08.0 /tmp/ptxdist-Update-2020.08.0
RUN cd /tmp/ptxdist-Update-2020.08.0 \
  && make install \
  && cd - \
  && rm -rf /tmp/ptxdist-Update-2020.08.0

RUN mkdir -p /home/user/ptxproj
RUN rm /usr/local/share/ca-certificates/*

FROM scratch

LABEL maintainer="WAGO GmbH & Co. KG"
LABEL version="3.0.1"
LABEL description="SDK Builder"

COPY --from=image / /

WORKDIR "/home/user/ptxproj"

ENTRYPOINT ["dumb-init", "--"]
