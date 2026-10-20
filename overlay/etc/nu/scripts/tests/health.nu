use std/assert
use ../bf-s6/health.nu *

const runner = "/usr/bin/bf/bf-healthcheck"
const cron_check = "/etc/bf/health.d/00-cron.nu"

# Create a temporary health.d directory containing the given checks
def checks_dir [
    checks: record  # Check file names and their contents
]: nothing -> string {
    let dir = mktemp --directory
    $checks | transpose name body | each {|x| $x.body | save $"($dir)/($x.name)" } | ignore
    $dir
}


#======================================================================================================================
# failed
#======================================================================================================================

export def failed__returns_nothing_when_all_checks_pass [] {
    let dir = checks_dir {"a.nu": "def main [] { print 'ok' }", "b.nu": "def main [] {}"}
    assert equal [] (with-env {BF_ETC_HEALTH_D: $dir} { failed })
    rm --force --recursive $dir
}

export def failed__returns_name_and_output_of_each_failing_check [] {
    let dir = checks_dir {
        "a.nu": "def main [] {}"
        "b.nu": "def main [] { print 'service is down'; exit 1 }"
        "c.nu": "def main [] { error make --unspanned {msg: 'broken'} }"
    }
    let result = with-env {BF_ETC_HEALTH_D: $dir} { failed }
    assert equal ["b.nu" "c.nu"] ($result | get name)
    assert equal "service is down" ($result | get output.0)
    assert ($result | get output.1 | str contains "broken")
    rm --force --recursive $dir
}

export def failed__ignores_files_without_nu_extension [] {
    let dir = checks_dir {"a.sh": "exit 1", "README": "not a check"}
    assert equal [] (with-env {BF_ETC_HEALTH_D: $dir} { failed })
    rm --force --recursive $dir
}

export def failed__errors_when_health_d_is_not_set [] {
    assert error {|| hide-env --ignore-errors BF_ETC_HEALTH_D; failed }
}

export def failed__returns_nothing_when_directory_is_missing [] {
    assert equal [] (with-env {BF_ETC_HEALTH_D: "/tmp/health.d-does-not-exist"} { failed })
}


#======================================================================================================================
# scripts
#======================================================================================================================

export def runner__is_found_on_path [] {
    # Docker runs the health check by name - nothing is in /usr/local/bin, so mounting a directory there is safe
    assert equal $runner (which bf-healthcheck | get path.0)
}

export def scripts__parse [] {
    for path in [$runner $cron_check] {
        let result = ^$nu.current-exe --no-config-file --commands $"nu-check ($path)" | complete
        assert equal "true" ($result.stdout | str trim) $"($path) does not parse: ($result.stderr)"
    }
}
