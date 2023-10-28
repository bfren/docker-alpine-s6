use bf

# Write a nice finish message when a service is stopped, optionally also terminating the container
export def finish [
    --terminate (-t)    # Terminate container
] {
    # echo service finish debug message.
    bf write debug "Finished." svc/finish

    # terminate the container if the terminate flag is set -
    # use executable to avoid cyclical module import
    if $terminate { ^bf-cont-terminate }
}

# Bring a service down
export def down [
    name: string    # The service name
] {
    bf write debug $"Stopping ($name) service." svc/down
    let result = { ^s6-rc -v 2 -d change $name } | bf handle -c
    match $result {
        111 => {
            bf write debug $"svc down has probably been called too early for ($name) - try again." svc/down
        },
        $code if $code > 0 => {
            $result | print
            bf write error --code $code $"s6-rc failed to bring down service ($name)." svc/down
        }
        _ => {
            bf write $"($name) service stopped." svc/down
        }
    }
}

# Returns true if service $name is running
export def is_up [
    name: string    # The service name
] {
    # make sure the S6_SERVICES_DIR is set
    let s6_svc_dir = ($env | get --ignore-errors S6_SERVICES_DIR)
    if $s6_svc_dir == "" { bf write error "Environment variable S6_SERVICES_DIR is not set." svc/is_up }

    # make sure S6_SERVICES_DIR exists
    if ($s6_svc_dir | bf fs is_not_dir) { bf write error $"S6_SERVICES_DIR does not exist: ($s6_svc_dir)." }

    # use s6-svstat to check service $name is running
    { ^s6-svstat -u $"($s6_svc_dir)/($name)" } | handle -c | $in == 0
}
