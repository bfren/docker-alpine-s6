#!/bin/bash


#
#   Get correct installer for target platform
#

case "$TARGETPLATFORM" in
    "linux/amd64")
        INSTALLER="s6-overlay-amd64-installer"
        ;;
    "linux/arm/v6")
        ;;&
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

INSTALLER_URL="https://github.com/just-containers/s6-overlay/releases/download/v$S6_VERSION/$INSTALLER"
curl -L -o "/tmp/$INSTALLER" "$INSTALLER_URL"

chmod +x "/tmp/$INSTALLER" && "/tmp/$INSTALLER"
