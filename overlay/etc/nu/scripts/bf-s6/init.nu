use bf
use cont.nu

# Initialise the container by executing all scripts contained in init.d
export def main [] {
    # store incoming environment variables
    bf env store

    # environment variables are not available yet so need to hard code the init.d directory
    let init_d = $"(bf env ETC)/init.d"

    # execute each initialisation script
    # we don't use 'each' because of a bug that doesn't redirect stdout of a child process
    bf write "Initialising container." init
    if ($init_d | path exists) {
        let init_files = $"($init_d)/*.nu" | into glob | ls --full-paths $in | get name | sort --natural
        let count = $init_files | length
        mut x = 0; loop { if $x >= $count { break } ; $init_files | get $x | execute $in ; $x = $x + 1}
    }
    bf env x_clear

    # output additional info when debug is enabled
    if (bf env debug) {
        # Show build information
        bf write "Build information." init
        bf build show

        # Show all environment variables that have been configured during initialisation
        bf write "bfren platform variables." init
        bf env load
        bf env show
    }

    return
}

# Execute a script within the init.d directory and exit on failure
def execute [
    filename: string    # Full path to script file
]: nothing -> any {
    bf write $"($filename | path basename)." init/execute
    try { bf x $filename } catch { exit 1 }
}
