use bf
use env.nu
use svc.nu

# The presence of this file indicates that another service is already bringing the dontainer down
const terminating = /tmp/terminating

# Terminate the container
export def-env terminate [] {
    # output a message to say the container is already terminating
    let already_terminating = {|| bf write debug "Container already being terminated." cont/terminate }

    # check if terminate has already been called (multiple services may try to bring it down)
    if ($terminating | path exists) {
        do $already_terminating
        return
    }

    # create file to indicate that the container is terminating
    date now | save --force $terminating

    # another check - if cron is down, the container is already being terminated
    if not (svc is_up cron) {
        do $already_terminating
        return
    }

    # if we end up here, we need to halt the container
    bf write notok "Terminating container, goodbye." cont/terminate

    # kill the init process
    let init_pid = pidof rc.init
    if $init_pid != "" {
        kill --force ($init_pid | into int)
    }

    # bring the container down
    halt
}
