# Execute a script with the container environment
export def main [
    path: string    # Absolute path to the file to execute
] {
    let name = if ($path | str length) > 15 { $path | path basename } else { $path }
    with-env [BF_E $name] { /command/with-contenv nu $path }
}
