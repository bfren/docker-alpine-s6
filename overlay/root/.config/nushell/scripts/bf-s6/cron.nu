use bf

# Run cron parts for a specified directory
export def main [
    directory: string   # The cron directory to run
    --quiet (-q)        # Make 'running cron' message debug only
] {
    # build path to requested cron directory
    let path = $"(bf env req CRON_D)/($directory)"

    # ensure cron directory exists
    if not ($path | path exists) { bf write error $"Cron directory does not exist: ($path)." }

    # output running message
    if $quiet {
        bf write debug $"($path)."
    } else {
        bf write $"($path)."
    }

    # use run-parts to execute cron jobs
    let result = do { ^run-parts --exit-on-error $path } | complete
    if $result.exit_code > 0 { bf write error --code $result.exit_code ($result.stderr | str trim) }
}