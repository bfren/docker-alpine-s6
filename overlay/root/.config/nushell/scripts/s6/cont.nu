use bf
use env.nu

# Terminate the container
export def terminate [] {
    # check if it has already been called (multiple services may try to bring it down).
    if (bf env check BF_TERMINATING) {
        bf write debug "Container already being terminated." cont/terminate
        return
    }

    # mark the container as terminating
    env TERMINATING 1

    # terminate all running services (will stop / restart the container depending on restart policy).
    # if cron is up, we need to halt the container
    # if cron is down, the container is already being terminated
    let stat = s6-svstat -u $"($env.S6_SERVICES)/cron"
    if $stat != null {
        bf write notok "Terminating container, goodbye." cont/terminate
        halt
    } else {
        bf write debug "Container already being terminated." cont/terminate
    }
}
