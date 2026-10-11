use bf
use svc.nu

# The presence of this file indicates that another service is already bringing the dontainer down
const terminating = "/run/bf-terminating"

# Terminate the container
export def terminate []: nothing -> nothing {
    # output a message to say the container is already terminating
    let already_terminating = {|| bf write debug "Container already being terminated." cont/terminate ; exit 0 }

    # check if terminate has already been called (multiple services may try to bring it down)
    if ($terminating | path exists) { do $already_terminating }

    # create file to indicate that the container is terminating
    date now | save --force $terminating

    # if we end up here, we need to halt the container
    bf write notok "Terminating container, goodbye." cont/terminate

    # bring the container down
    ^halt

    # return nothing
    return
}

# Remove the terminating marker - called during initialisation in case it survived a container restart
export def reset []: nothing -> nothing {
    rm --force $terminating

    # return nothing
    return
}
