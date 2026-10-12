use std/assert
use ../bf-s6/cont.nu *


#======================================================================================================================
# reset
#======================================================================================================================

# a single test so parallel tests cannot race on the shared marker file
export def reset__removes_marker_and_succeeds_when_missing [] {
    let marker = "/run/bf-terminating"
    date now | save --force $marker

    reset
    let removed = not ($marker | path exists)
    let result = try { reset ; "ok" } catch {|e| $e.msg }

    assert equal true $removed "marker was not removed"
    assert equal "ok" $result "reset failed when marker was missing"
}
