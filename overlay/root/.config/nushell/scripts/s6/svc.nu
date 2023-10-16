use cont.nu

# Write a nice finish message when a service is stopped, optionally also terminating the container
export def finish [
    --terminate (-t)    # Terminate container
] {
    # echo service finish debug message.
    bf write debug "Finished." svc/finish

    # terminate the container if the terminate flag is set.
    if $terminate { cont terminate }
}
