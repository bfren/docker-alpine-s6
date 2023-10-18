use bf
bf env load -e

# Set environment variables
def main [] {
    bf env IMAGE $"(bf fs read /BF_IMAGE)"
    bf env VERSION $"(bf fs read /BF_VERSION)"

    const etc = "/etc/bf"
    bf env CH_D $"($etc)/ch.d"
    bf env INIT_D $"($etc)/init.d"
    bf env TEMPLATES $"($etc)/templates"
    bf env SRC $"($etc)/src"

    bf env CRON_LOG_FILE "/var/log/cron.log"

    # return nothing
    return
}
