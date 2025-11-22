use bf
use bf-s6
bf env load

# Generate default crontab
def main []: nothing -> nothing {
    # generate crontab
    bf-s6 crontab generate_default

    # return nothing
    return
}
