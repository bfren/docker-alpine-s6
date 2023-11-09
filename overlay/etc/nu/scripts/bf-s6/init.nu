use bf
use cont.nu

# Initialise the container by executing all scripts contained in init.d
export def main [] {
    # store incoming environment variables
    bf env store

    # environment variables are not available yet so need to hard code the init.d directory
    let $init_d = $"(bf env ETC)/init.d"

    # execute each initialisation script
    bf write "Initialising container." init
    if ($init_d | path exists) { ls --full-paths $init_d | get name | sort | each {|x| execute $x } }
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
}

# Execute a script within the init.d directory
def execute [
    filename: string    # Full path to script file
] {
    bf write $"($filename | path basename)." init/execute
    try {
        bf x $filename
    } catch {
        bf write error $"Error running ($filename)." init/execute
    }
}
