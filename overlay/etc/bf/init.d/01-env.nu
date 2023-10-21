use bf
use bf-s6

# Set environment variables
def main [] {
    # store system environment
    bf env store

    # set image info
    let etc = bf env ETC
    cd $etc
    bf env set IMAGE $"(bf fs read IMAGE)"
    bf env set VERSION $"(bf fs read VERSION)"

    # set bf directories
    bf env set CH_D $"($etc)/ch.d"
    bf env set INIT_D $"($etc)/init.d"
    bf env set TEMPLATES $"($etc)/templates"
    bf env set SRC $"($etc)/src"

    # set cron info
    bf env set CRON_D "/etc/periodic"
    bf env set CRON_LOG_FILE "/var/log/cron.log"

    # return nothing
    return
}
