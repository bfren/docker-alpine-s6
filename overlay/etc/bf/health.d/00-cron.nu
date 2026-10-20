use bf

# Check the cron service is running
def main [] {
    let up = { ^s6-svstat -u /run/service/cron } | bf handle -i
    if $up != "true" { bf write error "The cron service is not running." healthcheck/cron }
}
