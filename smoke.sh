#!/bin/sh

#======================================================================================================================
# Smoke test: start the image normally (under S6, not with --entrypoint) and check the container lifecycle:
#   1. initialisation completes and cron starts
#   2. crond is supervised directly by s6-supervise (i.e. every run script and wrapper uses exec)
#   3. restarting cron (s6-svc -r) gives it a new PID and does not stop the container
#   4. killing cron (s6-svc -k = SIGKILL, a failure) terminates the container
#   5. docker stop shuts down cleanly without terminating via the finish script
#
# Usage: smoke.sh IMAGE_TAG
#======================================================================================================================

set -eu

IMAGE=${1:?Usage: smoke.sh IMAGE_TAG}
NAME=smoke-$$
SVC=/run/service/cron

# write a failure message, show the end of the container log, remove the container and exit
fail() {
    echo "SMOKE TEST FAILED: $*"
    docker logs ${NAME} 2>&1 | tail -n 40
    docker rm -f ${NAME} > /dev/null 2>&1 || true
    exit 1
}

# run a command inside the container
in_container() { docker exec ${NAME} sh -c "$1" 2> /dev/null; }

# true if the container is running
running() { [ "$(docker inspect -f '{{.State.Running}}' ${NAME} 2> /dev/null)" = "true" ]; }

# true if the container is not running
stopped() { ! running; }

# true if cron is up according to s6
cron_up() { [ "$(in_container "/command/s6-svstat -u ${SVC}")" = "true" ]; }

# PID of crond
crond_pid() { in_container "pidof crond"; }

# wait up to $1 seconds for the remaining arguments (a command) to succeed
wait_for() {
    T=$1 ; shift
    while [ ${T} -gt 0 ] ; do
        "$@" && return 0
        sleep 1 ; T=$((T - 1))
    done
    return 1
}

# start a container and wait for cron
start() {
    docker run -d --name ${NAME} ${IMAGE} > /dev/null
    wait_for 30 cron_up || fail "cron did not start within 30s"
}

echo "Smoke testing ${IMAGE}."

# 1. container initialises and cron starts
start
echo " .. cron started"

# 2. crond is a direct child of s6-supervise
PID=$(crond_pid)
PARENT=$(in_container "cat /proc/\$(awk '{print \$4}' /proc/${PID}/stat)/comm")
[ "${PARENT}" = "s6-supervise" ] || fail "crond's parent is '${PARENT}', expected 's6-supervise' (missing exec?)"
echo " .. crond is supervised directly by s6-supervise"

# 3. restarting cron gives a new PID and keeps the container running
docker exec ${NAME} /command/s6-svc -r ${SVC}
new_pid() { cron_up && [ -n "$(crond_pid)" ] && [ "$(crond_pid)" != "${PID}" ]; }
wait_for 15 new_pid || fail "cron did not restart with a new PID"
sleep 5
running || fail "container stopped after cron was restarted"
echo " .. cron restarted and the container is still running"

# 4. killing cron counts as a failure and terminates the container
docker exec ${NAME} /command/s6-svc -k ${SVC}
wait_for 30 stopped || fail "container did not terminate after cron was killed"
docker logs ${NAME} 2>&1 | grep -q "Terminating container" || fail "container stopped but not via the finish script"
docker rm -f ${NAME} > /dev/null
echo " .. killing cron terminated the container"

# 5. docker stop shuts down cleanly, without the finish script terminating the container
start
docker stop -t 20 ${NAME} > /dev/null
docker logs ${NAME} 2>&1 | grep -q "Terminating container" && fail "finish script terminated the container during docker stop"
docker rm -f ${NAME} > /dev/null
echo " .. docker stop shut down cleanly"

echo "Smoke test passed."
