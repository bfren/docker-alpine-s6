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

    # set timezone - this installs tzdata, so it fails without network access (or with an unknown timezone); keep the
    # current timezone rather than stopping the container
    try { bf tz $tz } catch { bf write notok $"Unable to set timezone to ($tz) - keeping (bf tz current)." }

    # return nothing
    return
}
