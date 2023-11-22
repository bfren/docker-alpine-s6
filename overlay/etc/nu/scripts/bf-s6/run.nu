use bf

# Run preflight checks before executing process
export def preflight [] {
    # manually set executing script
    bf env x_set --override run cron

    # if we get here we are ready to start cron
    bf write "Starting cron in foreground mode."
}
