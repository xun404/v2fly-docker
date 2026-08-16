FROM --platform=${TARGETPLATFORM} alpine:latest
LABEL maintainer="V2Log <mx@rmbz.net>"

WORKDIR /tmp
ARG TARGETPLATFORM
ARG TAG
COPY v2log.sh "${WORKDIR}"/v2log.sh

RUN set -ex \
    && apk add --no-cache ca-certificates openssl \
    && mkdir -p /etc/v2log /usr/local/share/v2log /var/log/v2log \
    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/v2log/access.log \
    && ln -sf /dev/stderr /var/log/v2log/error.log \
    && chmod +x "${WORKDIR}"/v2log.sh \
    && "${WORKDIR}"/v2log.sh "${TARGETPLATFORM}" "${TAG}"

ENTRYPOINT ["/usr/bin/v2log", "-config", "/etc/v2log/config.json"]
