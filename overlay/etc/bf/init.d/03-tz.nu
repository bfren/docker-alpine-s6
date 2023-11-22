use bf
bf env load

# Set timezone
def main [] {
    # if timezone is not defined, return
    let tz = bf env --safe TZ
    if $tz == "" { return }

    # set timezone
    bf tz $tz

    # return nothing
    return
}
