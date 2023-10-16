use bf
use s6
s6 env set_executable

# Set environment variables
def main [] {
    s6 env BF_IMAGE $"(bf fs read /BF_IMAGE)"
    s6 env BF_VERSION $"(bf fs read /BF_VERSION)"

    const etc = "/etc/bf"
    s6 env BF_CH_D $"($etc)/ch.d"
    s6 env BF_INIT_D $"($etc)/init.d"
    s6 env BF_TEMPLATES $"($etc)/templates"
    s6 env BF_SRC $"($etc)/src"

    s6 env BF_CRON_LOG_FILE "/var/log/cron.log"

    s6 env S6_SERVICES "/run/s6-rc/servicedirs"

    # return nothing
    return
}
