use bf
use cont.nu

# Initialise the container by executing all scripts contained in init.d
export def main [] {
    # Environment variables are not available yet so need to hard code the init.d directory
    let $init_d = $"(bf env ETC)/init.d"

    # Execute each initialisation script
    bf write "Initialising container." init
    if ($init_d | path exists) { ls --full-paths $init_d | get name | sort | each {|x| execute $x } }
    bf env x_clear

    # Show all environment variables that have been configured during initialisation
    bf write "bfren platform environment variables." init
    bf env load
    bf env show

    # Complete
    bf write ok "Initialisation complete." init
}

# Execute a script within the init.d directory
def execute [
    filename: string    # Full path to script file
] {
    bf write $"($filename | path basename): Running." init/execute
    try {
        bf x $filename
    } catch {
        bf write error $"Error running ($filename)." init/execute
    }
}
