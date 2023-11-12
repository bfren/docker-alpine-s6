use bf

# Append an instruction to the default crontab
export def append [
    command: string
    --min (-m): string = "*"
    --hour (-h): string = "*"
    --day (-d): string = "*"
    --month (-M): string = "*"
    --weekday (-w): string = "*"
] {
    # get variables
    let crontab = bf env CRONTAB_ROOT
    let pad = { $in | fill -a left -c " " -w 7 }

    # if crontab doesn't exist, generate it
    if ($crontab | bf fs is_not_file) { generate }

    # create padded crontab string
    let pattern = [
        ($min | do $pad)
        ($hour | do $pad)
        ($day | do $pad)
        ($month | do $pad)
        ($weekday | do $pad)
    ] | str join

    # append to crontab
    $"(char newline)($pattern)($command)" | save --append $crontab
}

# Generate the default crontab
export def generate [] { bf esh template (bf env CRONTAB_ROOT) }
