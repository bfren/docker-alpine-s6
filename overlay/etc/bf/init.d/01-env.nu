use bf
bf env load

# Set environment variables
def main [] {
    # set image info
    let etc = bf env ETC
    cd $etc
    bf env set IMAGE $"(bf fs read IMAGE)"
    bf env set VERSION $"(bf fs read VERSION)"

    # set bf directories
    bf env set ETC_CH_D $"($etc)/ch.d"
    bf env set ETC_INIT_D $"($etc)/init.d"
    bf env set ETC_TEMPLATES $"($etc)/templates"
    bf env set ETC_SRC $"($etc)/src"

    # set cron info
    bf env set CRON_CRONTABS "/etc/crontabs"
    bf env set CRON_D "/etc/periodic"
    bf env set CRON_LOG "/var/log/cron"
    bf env set CRON_LOG_FILE "/var/log/cron.log"

    # return nothing
    return
}
