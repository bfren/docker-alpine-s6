use std/assert
use ../bf-s6/esh.nu *


#======================================================================================================================
# template
#======================================================================================================================

export def template__generates_output_from_template_with_matching_name [] {
    let templates = mktemp --directory
    let output_dir = mktemp --directory
    let output = $"($output_dir)/app.conf"
    'greeting = <%= "${BF_ESH_TEST_GREETING}" %>' | save $"($templates)/app.conf.esh"

    let result = with-env {BF_ETC_TEMPLATES: $templates, BF_ESH_TEST_GREETING: "hello"} { template $output }

    assert equal $output $result
    assert equal "greeting = hello" (open --raw $output | str trim)
}
