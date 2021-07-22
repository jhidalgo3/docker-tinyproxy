FROM alpine:3.11

MAINTAINER jhidalgo3

ENV TINYPROXY_VERSION=1.11.0

RUN adduser -D -u 2000 -h /var/run/tinyproxy -s /sbin/nologin tinyproxy tinyproxy \
  && apk --update add -t build-dependencies \
    make \
    automake \
    autoconf \
    g++ \
    asciidoc \
    git \
  && rm -rf /var/cache/apk/* \
  && git clone -b ${TINYPROXY_VERSION} --depth=1 https://github.com/tinyproxy/tinyproxy.git /tmp/tinyproxy \
  && cd /tmp/tinyproxy \
  && ./autogen.sh \
  && ./configure --enable-transparent --prefix="" \
  && make \
  && make install \
  && mkdir -p /var/log/tinyproxy \
  && chown tinyproxy:tinyproxy /var/log/tinyproxy \
  && cd / \
  && rm -rf /tmp/tinyproxy \
  && apk del build-dependencies \
  && apk add --no-cache curl

COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

ADD cert/* /tmp/cert/
RUN apk add --no-cache ca-certificates && \
    mkdir /usr/share/ca-certificates/extra && \
    cp -R /tmp/cert/* /usr/share/ca-certificates/ && \
    update-ca-certificates

USER root

EXPOSE 8888

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["tinyproxy", "-d"]
