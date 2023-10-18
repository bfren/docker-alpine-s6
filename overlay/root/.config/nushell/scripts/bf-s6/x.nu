# Set BF_E to the name of the script and then execute it
export def main [
    path: string        # Absolute path to the file to execute
    --as (-u): string   # Optionally execute the script as this user
] {
    let name = if ($path | str length) > 15 { $path | path basename } else { $path }
    with-env [BF_E $name] { nu $path }
}
