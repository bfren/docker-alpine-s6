use bf
bf env set_executable

# Set environment variables
def main [] {
    # store system environment
    bf env store

    # set image info
    bf env IMAGE $"(bf fs read /BF_IMAGE)"
    bf env VERSION $"(bf fs read /BF_VERSION)"

    # set bf directories
    const etc = "/etc/bf"
    bf env CH_D $"($etc)/ch.d"
    bf env INIT_D $"($etc)/init.d"
    bf env TEMPLATES $"($etc)/templates"
    bf env SRC $"($etc)/src"

    # set cron info
    bf env CRON_LOG_FILE "/var/log/cron.log"

    # return nothing
    return
}
