use bf

# Bring a service down
export def down [
    name: string    # The service name
]: nothing -> nothing {
    bf write debug $"Stopping ($name) service." svc/down
    let result = { ^s6-rc -v 2 -d change $name } | bf handle -c svc/down
    match $result {
        111 => {
            bf write debug $"svc down has probably been called too early for ($name) - try again." svc/down
        },
        $code if $code > 0 => {
            $result | print
            bf write error $"s6-rc failed to bring down service ($name)." svc/down
        }
        _ => {
            bf write $"($name) service stopped." svc/down
        }
    }

    # return nothing
    return
}

# Exit preflight checks early
export def exit_preflight [
    module: string          # The module that is exiting early, without the 'bf-' prefix
    --sleep (-s): duration  # Sleep for this amount of time before exiting
]: string -> nothing {
    # output the reason if set
    let reason = $in
    if ($reason | is-not-empty) { bf write warn $"Preflight exit: ($reason)." }

    # set early exit environment variable
    bf env set $"($module)_PREFLIGHT_EARLY_EXIT" 1

    # sleep if set
    if ($sleep | is-not-empty) { sleep $sleep }

    # exit Nushell
    exit 0
}

# Write a nice finish message when a service is stopped, optionally also terminating the container.
# s6-supervise runs ./finish with two arguments: the exit code of ./run (256 if it was killed by a signal),
# and the number of the signal that killed it - pass these through from the finish script using ...$args
export def finish [
    ...args             # Arguments passed by s6-supervise to ./finish: exit code and signal number
    --terminate (-t)    # Terminate the container if the service failed
]: nothing -> nothing {
    # echo service finish debug message
    let code = $args | get --optional 0 | default "-" | into string
    let signal = $args | get --optional 1 | default "-" | into string
    bf write debug $"Finished with exit code ($code) and signal ($signal)." svc/finish

    # terminate the container if the terminate flag is set and the service failed -
    # use executable to avoid cyclical module import
    if $terminate and (is_failure ...$args) { ^bf-cont-terminate }

    # return nothing
    return
}

# Returns true if the exit code and signal passed by s6-supervise to ./finish mean the service failed.
# A service has stopped deliberately (and so has not failed) if it:
#   - exited with code 0 (e.g. a daemon that shuts down cleanly when it receives its down signal)
#   - was killed by SIGTERM (sent by s6-svc -r / -d, and to all services when the container is stopping)
# If no arguments are passed (e.g. an older finish script) the service is treated as having failed,
# which keeps the previous behaviour of always terminating the container.
export def is_failure [
    ...args     # Exit code (256 if the service was killed by a signal) and signal number
]: nothing -> bool {
    if ($args | is-empty) { return true }

    let code = $args | get 0 | into int
    let signal = $args | get --optional 1 | default 0 | into int
    let sigterm = 15
    let stopped_cleanly = $code == 0
    let stopped_by_sigterm = $code == 256 and $signal == $sigterm
    not ($stopped_cleanly or $stopped_by_sigterm)
}

# Returns true if service $name is running
export def is_up [
    name: string    # The service name
]: nothing -> bool {
    # use s6-svstat to check service $name is running - it prints 'true' or 'false' (the exit code is 0 either way)
    let args = [
        "-u"
        (service_dir $name)
    ]
    { ^s6-svstat ...$args }
        | bf handle -i svc/is_up
        | $in == "true"
}

# Restart a service: s6-supervise sends it the down signal (SIGTERM unless the service has a down-signal file),
# waits for it to stop and starts it again - this does not terminate the container because the service is still
# wanted up and is stopped by SIGTERM (see is_failure)
export def restart [
    name: string                        # The service name
    --timeout (-t): duration = 10sec    # Maximum time to wait for the service to restart
]: nothing -> nothing {
    bf write debug $"Restarting ($name) service." svc/restart

    # -r   restart the service
    # -wr  wait until the service has been restarted
    # -T   give up waiting after this many milliseconds
    let ms = $timeout / 1ms | into int
    let on_failure = {|code: int, stderr: string|
        bf write error $"Unable to restart ($name) service within ($timeout) - exit code ($code)." svc/restart
    }
    let args = [
        "-r"
        "-wr"
        "-T"
        $ms
        (service_dir $name)
    ]
    { ^s6-svc ...$args } | bf handle -I -f $on_failure svc/restart

    bf write $"($name) service restarted." svc/restart

    # return nothing
    return
}

# Returns the path to the live service directory for service $name
def service_dir [
    name: string    # The service name
]: nothing -> string {
    # make sure the S6_SERVICES_DIR is set
    let s6_svc_dir = ($env | get --optional S6_SERVICES_DIR)
    if ($s6_svc_dir | is-empty) { bf write error "Environment variable S6_SERVICES_DIR is not set." svc/service_dir }

    # make sure S6_SERVICES_DIR exists
    if ($s6_svc_dir | bf fs is_not_dir) { bf write error $"S6_SERVICES_DIR does not exist: ($s6_svc_dir)." svc/service_dir }

    $"($s6_svc_dir)/($name)"
}
