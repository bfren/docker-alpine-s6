#!/bin/bash


#
#   Get correct installer for target platform
#

case "$TARGETPLATFORM" in
    "linux/amd64")
        INSTALLER="s6-overlay-amd64-installer"
        ;;
    "linux/arm/v6")
        INSTALLER="s6-overlay-arm-installer"
        ;;
    "linux/arm/v7")
        INSTALLER="s6-overlay-armhf-installer"
        ;;
    "linux/arm64")
        INSTALLER="s6-overlay-aarch64-installer"
        ;;
    *)
esac

if [ -z "$INSTALLER" ] ; then
    echo "Unsupported target platform: $TARGETPLATFORM"
    exit
fi


#
#   Download and run installer
#

URL="https://github.com/just-containers/s6-overlay/releases/download/v$S6_VERSION/$INSTALLER"
echo "$URL"
curl -L -o "/tmp/$INSTALLER" "$URL"
chmod +x "/tmp/$INSTALLER" && "/tmp/$INSTALLER" /
