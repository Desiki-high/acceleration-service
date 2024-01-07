FROM golang:1.21.5 AS build

ARG NYDUS_VERSION=v2.2.4

ARG NYDUS_LINUX_ARM64_SHA256SUM="812398992eb8bb7993eb38a2bc6b222439037cfda9e7b6070937a7d55a2b189a"

# Install acceld
COPY ./ /accel

# Install nydus component
RUN wget https://github.com/dragonflyoss/image-service/releases/download/$NYDUS_VERSION/nydus-static-$NYDUS_VERSION-linux-arm64.tgz
RUN echo "$NYDUS_LINUX_ARM64_SHA256SUM  nydus-static-$NYDUS_VERSION-linux-arm64.tgz" | tee nydus-static-$NYDUS_VERSION-linux-arm64.tgz.sha256sum
RUN sha256sum -c nydus-static-$NYDUS_VERSION-linux-arm64.tgz.sha256sum
RUN tar xzvf nydus-static-$NYDUS_VERSION-linux-arm64.tgz && mv nydus-static/nydus-image /usr/local/bin/.

# Build acceld image
FROM photon:5.0
COPY --from=build /accel/acceld /accel/accelctl /usr/local/bin/nydus-image /usr/local/bin/
COPY ./script/release/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
