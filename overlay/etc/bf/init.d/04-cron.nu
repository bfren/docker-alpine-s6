use bf
use bf-s6
bf env load

# Generate default crontab
def main [] { bf-s6 crontab generate }
