#!/bin/sh


#
#   Get correct installer for target platform
#

case "$TARGETPLATFORM" in
    "linux/386")
        INSTALLER="s6-overlay-x86-installer"
        ;;
    "linux/amd64")
        INSTALLER="s6-overlay-amd64-installer"
        ;;
    "linux/arm/v6")
        INSTALLER="s6-overlay-arm-installer"
        ;;
    "linux/arm/v7")
        INSTALLER="s6-overlay-armhf-installer"
        ;;
    "linux/arm64"
        INSTALLER="s6-overlay-aarch64-installer"
        ;;
    "linux/ppc64le")
        INSTALLER="s6-overlay-ppc64le-installer"
        ;;
    *)
esac

if [ -z "$INSTALLER" ] ; then
    echo "Unknown target platform: $TARGETPLATFORM"
    exit
fi

#
#   Install curl; download and run installer
#

apk update
apk upgrade
apk add curl

curl "https://github.com/just-containers/s6-overlay/releases/download/v$S6_VERSION/$INSTALLER" /tmp/
chmod +x "/tmp/$INSTALLER" && "/tmp/$INSTALLER" /

apk remove curl
rm -rf /var/cache/apk/*
