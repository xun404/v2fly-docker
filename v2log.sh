#!/bin/sh

# Set ARG
PLATFORM=$1
if [ -z "$PLATFORM" ]; then
    ARCH="64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="32"
            ;;
        linux/amd64)
            ARCH="64"
            ;;
        linux/arm/v6)
            ARCH="arm32-v6"
            ;;
        linux/arm/v7)
            ARCH="arm32-v7a"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64-v8a"
            ;;
        linux/ppc64le)
            ARCH="ppc64le"
            ;;
        linux/s390x)
            ARCH="s390x"
            ;;
        *)
            ARCH=""
            ;;
    esac
fi
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1

# Download files
V2LOG_FILE="v2log-linux-${ARCH}.zip"
DGST_FILE="v2log-linux-${ARCH}.zip.dgst"
echo "Downloading binary file: ${V2LOG_FILE}"
echo "Downloading binary file: ${DGST_FILE}"

TAG=$(wget -qO- https://raw.githubusercontent.com/v2fly/docker/master/ReleaseTag | head -n1)
wget -O ${PWD}/v2log.zip https://github.com/v2fly/v2ray-core/releases/download/${TAG}/${V2LOG_FILE} > /dev/null 2>&1
wget -O ${PWD}/v2log.zip.dgst https://github.com/v2fly/v2ray-core/releases/download/${TAG}/${DGST_FILE} > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${V2LOG_FILE} ${DGST_FILE}" && exit 1
fi
echo "Download binary file: ${V2LOG_FILE} ${DGST_FILE} completed"

# Check SHA512
LOCAL=$(openssl dgst -sha512 v2log.zip | sed 's/([^)]*)//g')
STR=$(cat v2log.zip.dgst | grep 'SHA512' | head -n1)

if [ "${LOCAL}" = "${STR}" ]; then
    echo " Check passed" && rm -fv v2log.zip.dgst
else
    echo " Check have not passed yet " && exit 1
fi

# Prepare
echo "Prepare to use"
unzip v2log.zip && chmod +x v2ray v2ctl
mv v2ray v2log
mv v2log v2ctl /usr/bin/
mv geosite.dat geoip.dat /usr/local/share/v2log/
mv config.json /etc/v2log/config.json

# Clean
rm -rf ${PWD}/*
echo "Done"
