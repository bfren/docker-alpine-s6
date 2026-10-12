use std/assert
use ../bf-s6/svc.nu *


#======================================================================================================================
# is_failure
#======================================================================================================================

export def is_failure__clean_exit_returns_false [] {
    let result = is_failure 0 0

    assert equal false $result
}

export def is_failure__killed_by_sigterm_returns_false [] {
    let result = is_failure 256 15

    assert equal false $result
}

export def is_failure__killed_by_sigkill_returns_true [] {
    let result = is_failure 256 9

    assert equal true $result
}

export def is_failure__killed_by_sigsegv_returns_true [] {
    let result = is_failure 256 11

    assert equal true $result
}

export def is_failure__non_zero_exit_returns_true [] {
    let result = is_failure 1 0

    assert equal true $result
}

export def is_failure__no_arguments_returns_true [] {
    let result = is_failure

    assert equal true $result
}

export def is_failure__string_arguments_from_s6_are_converted [] {
    let result = is_failure "256" "15"

    assert equal false $result
}


#======================================================================================================================
# finish
#======================================================================================================================

# Run finish with a stub bf-cont-terminate first on PATH, and return true if the stub was called
# (the real executable would halt the test container)
def finish_e [
    --terminate     # Passed to finish
    ...args         # Exit code and signal, as s6 passes them
]: nothing -> bool {
    let dir = mktemp --directory
    let marker = $"($dir)/terminated"
    $"#!/bin/sh\ntouch ($marker)\n" | save $"($dir)/bf-cont-terminate"
    ^chmod +x $"($dir)/bf-cont-terminate"

    let path = [$dir] | append ($env.PATH | [$in] | flatten | str join (char esep) | split row (char esep))
    with-env { PATH: $path } { finish --terminate=($terminate) ...$args }

    $marker | path exists
}

export def finish__terminate_and_killed_by_sigterm_does_not_terminate [] {
    let result = finish_e --terminate 256 15

    assert equal false $result
}

export def finish__terminate_and_clean_exit_does_not_terminate [] {
    let result = finish_e --terminate 0 0

    assert equal false $result
}

export def finish__terminate_and_killed_by_sigkill_terminates [] {
    let result = finish_e --terminate 256 9

    assert equal true $result
}

export def finish__terminate_and_non_zero_exit_terminates [] {
    let result = finish_e --terminate 1 0

    assert equal true $result
}

export def finish__terminate_and_no_arguments_terminates [] {
    let result = finish_e --terminate

    assert equal true $result
}

export def finish__failure_without_terminate_does_not_terminate [] {
    let result = finish_e 256 9

    assert equal false $result
}


#======================================================================================================================
# launch
#======================================================================================================================

# launch replaces the current process, so run it in a child Nushell process and return the completed result -
# the commands are run from a script file (like an s6 run file) so Nushell sets CURRENT_FILE, FILE_PWD, etc.
def launch_e [
    commands: string    # Commands to run after importing bf-s6
]: nothing -> record {
    let script = $"(mktemp --directory)/run.nu"
    $"use bf-s6\n($commands)\n" | save $script
    ^$nu.current-exe --no-config-file $script | complete
}

export def launch__passes_arguments_to_executable [] {
    let result = launch_e r#'bf-s6 svc launch printf "%s|" "-c" "/etc/app.conf" "-d"'#

    assert equal "-c|/etc/app.conf|-d|" $result.stdout
}

export def launch__passes_spread_arguments_to_executable [] {
    let result = launch_e r#'let args = [ "-c" "/etc/app.conf" "-d" ] ; bf-s6 svc launch printf "%s|" ...$args'#

    assert equal "-c|/etc/app.conf|-d|" $result.stdout
}

export def launch__converts_non_string_arguments [] {
    let result = launch_e r#'let args = [ "-p" 6379 1.5 true ] ; bf-s6 svc launch printf "%s|" ...$args'#

    assert equal "-p|6379|1.5|true|" $result.stdout
}

export def launch__does_not_parse_flags_for_executable [] {
    let result = launch_e r#'bf-s6 svc launch printf "%s|" --foreground -f --config=/etc/app.conf'#

    assert equal "--foreground|-f|--config=/etc/app.conf|" $result.stdout
}

export def launch__replaces_current_process [] {
    let result = launch_e r#'print $nu.pid ; bf-s6 svc launch sh "-c" "echo $$"'#
    let pids = $result.stdout | lines

    assert equal 2 ($pids | length)
    assert equal ($pids | first) ($pids | last)
}

export def launch__returns_exit_code_of_executable [] {
    let result = launch_e r#'bf-s6 svc launch sh "-c" "exit 3"'#

    assert equal 3 $result.exit_code
}

export def launch__hides_nushell_and_bf_environment_variables [] {
    let result = launch_e r#'$env.BF_X = "test/launch" ; ^true ; bf-s6 svc launch env'#
    let hidden = [ "BF_X" "CURRENT_FILE" "FILE_PWD" "LAST_EXIT_CODE" "NU_VERSION" "PROCESS_PATH" ]
    let names = $result.stdout | lines | parse "{key}={val}" | get key

    assert equal [] ($names | where $it in $hidden)
}

export def launch__keeps_other_environment_variables [] {
    let result = launch_e r#'$env.BF_LAUNCH_TEST = "kept" ; bf-s6 svc launch env'#
    let names = $result.stdout | lines

    assert ("BF_LAUNCH_TEST=kept" in $names)
}
