use bf
use s6
s6 env set_executable

# Apply changes defined in ch.d directory
def main [] {
    # if init ch is not enabled, return
    if not (bf env check BF_ENABLE_INIT_CH) {
        write "Applying ch.d during init is disabled."
        return
    }

    # apply changes from each file
    ls --full-paths $env.BF_CH_D | sort --natural | each {|x| bf ch apply_file $x.name }

    # return nothing
    return
}
