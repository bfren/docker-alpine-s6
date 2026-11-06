use bf
use bf-s6

# Check the cron service is running
def main [] {
    if not (bf-s6 svc is_up cron) { bf write error "The cron service is not running." healthcheck/cron }
}
