use bf

# Run preflight checks before executing process
export def preflight [] {
    # manually set executing script
    bf env x_set cron/run

    # if we get here we are ready to start cron
    bf write "Starting cron in foreground mode."
}
