use bf
use env.nu

# Terminate the container
export def terminate [] {
    # output a message to say the container is already terminating
    let already_terminating = {|| bf write debug "Container already being terminated." cont/terminate }

    # check if it has already been called (multiple services may try to bring it down).
    if (bf env check TERMINATING) {
        do $already_terminating
        return
    }

    # mark the container as terminating
    env TERMINATING 1

    # if cron is down, the container is already being terminated
    let stat = s6-svstat -u $"($env.S6_SERVICES)/cron"
    if $stat == null {
        do $already_terminating
        return
    }

    # cron is up so we need to halt the container
    bf write notok "Terminating container, goodbye." cont/terminate

    # kill the init process
    let init_pid = pidof rc.init
    if $init_pid != "" {
        kill --force ($init_pid | into int)
    }

    # bring the container down
    halt
}
