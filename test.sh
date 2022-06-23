#!/bin/sh

timeout --signal=KILL 120s bash -c "docker run bfren/alpine-s6:${0} bf-image"
exit $?
