use bf
use bf-s6/cont

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
        let init_files = $"($init_d)/*.nu"
            | into glob
            | ls --full-paths $in
            | get name
            | sort --natural
        let count = $init_files | length
        mut x = 0 ; loop {
            if $x >= $count { break }
            $init_files
                | get $x
                | execute
            $x = $x + 1
        }
    }
    bf env unset X

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

    # return nothing
    return
}

# Execute a script within the init.d directory and exit on failure
def execute []: string -> nothing {
    # execute script file, catching errors
    # exit on error to bring the container down during init process
    let script = $in
    bf write $"($script | path basename)." init/execute
    try { bf x $script } catch { exit 1 }

    # return nothing
    return
}
