use bf
use cont.nu
use x.nu

# Initialise the container by executing all scripts contained in /etc/bf/init.d
export def main [] {
    # Environment variables are not available yet so need to hard code the init.d directory
    const $init_d = "/etc/bf/init.d"

    # Execute each initialisation script
    bf write "Initialising container." init
    if ($init_d | path exists) { ls --full-paths $init_d | get name | sort | each {|x| execute $x } }
    bf write ok "Initialisation complete." init
}

# Execute a script within the init.d directory
def execute [
    filename: string    # Full path to script file
] {
    bf write $"($filename | path basename): Running." init/execute
    try {
        x $filename
    } catch {
        bf write error $"Error running ($filename)." init/execute
    }
}
