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
