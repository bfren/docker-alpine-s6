use bf
use bf-s6
bf-s6 env set_executable

# Set environment variables
def main [] {
    bf-s6 env IMAGE $"(bf fs read /BF_IMAGE)"
    bf-s6 env VERSION $"(bf fs read /BF_VERSION)"

    const etc = "/etc/bf"
    bf-s6 env CH_D $"($etc)/ch.d"
    bf-s6 env INIT_D $"($etc)/init.d"
    bf-s6 env TEMPLATES $"($etc)/templates"
    bf-s6 env SRC $"($etc)/src"

    bf-s6 env CRON_LOG_FILE "/var/log/cron.log"

    # return nothing
    return
}
