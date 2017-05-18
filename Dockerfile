FROM alpine:latest
MAINTAINER Matt Bailey <m@mdb.io>

# global environment settings
ENV RCLONE_VERSION="current"
ENV PLATFORM_ARCH="amd64"

# install packages
RUN \
  apk -Uu add --no-cache \
  ca-certificates \
  bash \
  inotify-tools


# install build packages
RUN \
  apk -Uu add --no-cache --virtual=build-dependencies \
  wget \
  curl \
  unzip && \
  cd tmp && \
  wget -q http://downloads.rclone.org/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip && \
  unzip /tmp/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip && \
  mv /tmp/rclone-*-linux-${PLATFORM_ARCH}/rclone /usr/bin && \

  apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/community \
    shadow && \

  # cleanup
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/* \
    /var/tmp/* \
    /var/cache/apk/*

VOLUME ["/config"]

ENTRYPOINT ["rclone"]
