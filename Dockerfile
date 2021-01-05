FROM --platform=${TARGETPLATFORM} alpine:latest
LABEL maintainer "V2Log <mx@rmbz.net>"

WORKDIR /root
ARG TARGETPLATFORM

RUN set -ex \
	&& apk add --no-cache tzdata openssl ca-certificates \
	&& mkdir -p /etc/v2log /usr/local/share/v2log /var/log/v2log \	
	&& wget -O /root/v2log.sh https://raw.githubusercontent.com/xun404/v2fly-docker/master/v2log.sh > /dev/null 2>&1 \
        && chmod +x /root/v2log.sh \
	&& /root/v2log.sh "${TARGETPLATFORM}"

VOLUME /etc/v2log
CMD [ "/usr/bin/v2log", "-config", "/etc/v2log/config.json" ]
