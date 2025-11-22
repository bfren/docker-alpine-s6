use bf
bf env load

# Set timezone
def main []: nothing -> nothing {
    # if timezone is not defined, return
    let tz = bf env --safe TZ
    if ($tz | is-empty)  {
        bf write debug "Timezone not defined."
        return
    }

    # set timezone
    bf tz $tz

    # return nothing
    return
}
