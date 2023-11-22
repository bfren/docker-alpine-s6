use bf

# Append an instruction to the default crontab
#
# See (e.g.) https://crontab.guru/ for valid values
export def append [
    command: string                 # The command to run according to the pattern
    --min (-m): string = "*"        # Pattern: minute, e.g. 50 (every 50th minute past the hour) or */10 (every ten minutes)
    --hour (-h): string = "*"       # Pattern: hours, e.g. 4 (every 4am) or */8 (every eight hours)
    --day (-d): string = "*"        # Pattern: day of the month, e.g. 20 (every 20th of the month) or */2 (every two days)
    --month (-M): string = "*"      # Pattern: month of the year, e.g. 6 (every June) or */4 (every four months)
    --weekday (-w): string = "*"    # Pattern: weekday, e.g. 0 (every Sunday) or 1-5 (every Monday-Friday)
] {
    # get variables
    let crontab = bf env CRONTAB_ROOT
    let pad = { $in | fill -a left -c " " -w 8 }

    # if crontab doesn't exist, generate it
    if ($crontab | bf fs is_not_file) { generate }

    # create padded crontab pattern string
    let pattern = [
        ($min | do $pad)
        ($hour | do $pad)
        ($day | do $pad)
        ($month | do $pad)
        ($weekday | do $pad)
    ] | str join

    # append to crontab
    $"($pattern)($command)(char newline)" | save --append $crontab
}

# Generate the default crontab
export def generate [] { bf esh template (bf env CRONTAB_ROOT) }
