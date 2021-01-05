FROM --platform=${TARGETPLATFORM} alpine:latest
LABEL maintainer "V2Log <mx@rmbz.net>"

WORKDIR /root
ARG TARGETPLATFORM
COPY v2log.sh /root/v2log.sh

RUN set -ex \
	&& apk add --no-cache tzdata openssl ca-certificates \
	&& mkdir -p /etc/v2log /usr/local/share/v2log /var/log/v2log \
	&& chmod +x /root/v2log.sh \
	&& /root/v2log.sh "${TARGETPLATFORM}"

VOLUME /etc/v2log
CMD [ "/usr/bin/v2log", "-config", "/etc/v2log/config.json" ]
