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

curl "https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/$INSTALLER" /tmp/
chmod +x "/tmp/$INSTALLER" && "/tmp/$INSTALLER" /
