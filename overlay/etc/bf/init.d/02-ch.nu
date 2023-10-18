use bf
bf env load -e

# Apply changes defined in ch.d directory
def main [] {
    # if init ch is not enabled, return
    if not (bf env check ENABLE_INIT_CH) {
        bf write "Applying ch.d during init is disabled."
        return
    }

    # apply changes from each file
    ls --full-paths (bf env req CH_D) | sort --natural | each {|x| bf ch apply_file $x.name }

    # return nothing
    return
}
