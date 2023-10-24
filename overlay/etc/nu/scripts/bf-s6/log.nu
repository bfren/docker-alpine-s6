use bf

# Tail and forward the contents of a log file to stdout
export def forward [
    name: string    # The name of the log service
    path: string    # Absolute path to log file to forward to stdout
] {
    # if the file does not exist, wait and exit - S6 will bring the service back up to try again
    if (bf fs is_not_file $path) {
        let wait = 5sec
        bf write debug $"($path) not found, sleeping for ($wait)s." log/forward
        sleep $wait
        exit 0
    }

    # tail the specified file in a new process
    bf write $"Forwarding ($name) - ($path)." log/forward
    exec tail -F $path
}
