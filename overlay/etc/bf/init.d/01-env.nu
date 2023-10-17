use bf
use s6
s6 env set_executable

# Set environment variables
def main [] {
    s6 env IMAGE $"(bf fs read /BF_IMAGE)"
    s6 env VERSION $"(bf fs read /BF_VERSION)"

    const etc = "/etc/bf"
    s6 env CH_D $"($etc)/ch.d"
    s6 env INIT_D $"($etc)/init.d"
    s6 env TEMPLATES $"($etc)/templates"
    s6 env SRC $"($etc)/src"

    s6 env CRON_LOG_FILE "/var/log/cron.log"

    s6 env S6_SERVICES "/run/s6-rc/servicedirs"

    # return nothing
    return
}
