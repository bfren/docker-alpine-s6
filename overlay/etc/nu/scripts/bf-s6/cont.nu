use bf
use svc.nu

# The presence of this file indicates that another service is already bringing the dontainer down
const terminating = "/tmp/terminating"

# Terminate the container
export def terminate [] {
    # output a message to say the container is already terminating
    let already_terminating = {|| bf write debug "Container already being terminated." cont/terminate ; exit 0 }

    # check if terminate has already been called (multiple services may try to bring it down)
    if ($terminating | path exists) { do $already_terminating }

    # create file to indicate that the container is terminating
    date now | save --force $terminating

    # another check - if cron is down, the container is already being terminated
    if not (svc is_up cron) { do $already_terminating }

    # if we end up here, we need to halt the container
    bf write notok "Terminating container, goodbye." cont/terminate

    # bring the container down
    ^halt
}
