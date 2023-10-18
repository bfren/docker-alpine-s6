use bf

# Write a nice finish message when a service is stopped, optionally also terminating the container
export def finish [
    --terminate (-t)    # Terminate container
] {
    # echo service finish debug message.
    bf write debug "Finished." svc/finish

    # terminate the container if the terminate flag is set -
    # use executable to avoid cyclical module import
    if $terminate { bf-cont-terminate }
}

# Returns true if service $name is running
export def is_up [
    name: string    # The service name
] {
    # make sure the S6_SERVICES_DIR is set
    let s6_svc_dir = ($env | get --ignore-errors S6_SERVICES_DIR)
    if $s6_svc_dir == "" {
        bf write error "Environment variable S6_SERVICES_DIR is not set." svc/is_up
    }

    # make sure S6_SERVICES_DIR exists
    if not ($s6_svc_dir | path exists) {
        bf write error "S6_SERVICES_DIR does not exist: ($s6_svc_dir)."
    }

    # use s6-svstat to check service $name is running
    do { s6-svstat -u $"($s6_svc_dir)/($name)" } | complete | $in.exit_code == 0
}
