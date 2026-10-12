use std/assert
use ../bf-s6/crontab.nu *
use bf/fs.nu [make_temp_dir]


#======================================================================================================================
# add
#======================================================================================================================

export def add__appends_padded_line [] {
    let crontab = $"(make_temp_dir)/root"
    "" | save $crontab
    let expect = "*/5     2       *       *       1-5     my-command"

    with-env { BF_CRONTAB_ROOT: $crontab } { add "my-command" --min "*/5" --hour "2" --weekday "1-5" }
    let result = open --raw $crontab | lines | last

    assert equal $expect $result
}

export def add__appends_each_command_on_a_new_line [] {
    let crontab = $"(make_temp_dir)/root"
    "" | save $crontab

    with-env { BF_CRONTAB_ROOT: $crontab } {
        add "first"
        add "second"
    }
    let result = open --raw $crontab | lines | where ($it | is-not-empty) | each {|x| $x | split row " " | last }

    assert equal ["first" "second"] $result
}

export def add__generates_default_crontab_when_missing [] {
    let crontab = $"(make_temp_dir)/root"

    with-env { BF_CRONTAB_ROOT: $crontab, BF_ETC_TEMPLATES: "/etc/bf/templates" } { add "my-command" }
    let result = open --raw $crontab | lines

    assert (($result | where ($it | str ends-with "bf-cron daily") | length) == 1) "default crontab was not generated"
    assert str contains ($result | last) "my-command"
}


#======================================================================================================================
# generate_template
#======================================================================================================================

export def generate_template__unsupported_frequency_errors [] {
    let frequency = "5min"

    let result = try { generate_template $frequency "test" ; "no error" } catch {|e| $e.msg }

    assert equal $"'($frequency)' is not a supported cron frequency." $result
}
