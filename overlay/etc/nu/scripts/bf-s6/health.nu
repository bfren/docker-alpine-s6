use bf

# Run every check in health.d and stop with an error if any fail - used by bf-healthcheck
export def main [] {
    let failed = failed
    if ($failed | is-empty) { return }

    $failed | each {|x| bf write notok $"($x.name): ($x.output)" health } | ignore
    bf write error $"Failed health checks: ($failed | get name | str join ', ')." health
}

# Run every check in health.d (BF_ETC_HEALTH_D), returning the name and output of those that fail
export def failed []: nothing -> list<record<name: string, output: string>> {
    let health_d = bf env --safe ETC_HEALTH_D
    if $health_d == "" { bf write error "BF_ETC_HEALTH_D is not set - the container may not have finished initialising." health/failed }

    glob $"($health_d)/*.nu"
        | sort --natural
        | each {|x| run_check $x }
        | where exit_code != 0
        | select name output
}

# Run a check, returning its name, exit code and output
def run_check [
    path: string    # Absolute path to the check
]: nothing -> record<name: string, exit_code: int, output: string> {
    let result = bf x $path | complete
    {name: ($path | path basename), exit_code: $result.exit_code, output: ($result.stdout + $result.stderr | str trim)}
}
