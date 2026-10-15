use std/assert

const link = "/usr/local/bin/healthcheck"


#======================================================================================================================
# healthcheck link
#======================================================================================================================

export def link__points_to_bf_healthcheck [] {
    assert equal "symlink" ($link | path type) $"($link) should be a symlink"
    assert equal "/usr/bin/bf/bf-healthcheck" (^readlink $link | str trim)
}

export def link__script_parses_when_run_through_link [] {
    # Nushell resolves 'use bf' next to the path a script is run from - if the link were in /usr/bin (or /bin, which
    # is /usr/bin on some systems) it would find the /usr/bin/bf directory instead of the bf module, and fail
    let result = ^$nu.current-exe --no-config-file --commands $"nu-check ($link)" | complete

    assert equal "true" ($result.stdout | str trim) $"the health check script does not parse when run as ($link): ($result.stderr)"
}
