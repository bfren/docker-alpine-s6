use std/assert
use bf
use ../bf-s6/ch.nu *


#======================================================================================================================
# helpers
#======================================================================================================================

# Returns the octal mode of the input path
def mode []: string -> string { ^stat -c "%a" $in | str trim }

# Returns the uid:gid of the input path
def ids []: string -> string { ^stat -c "%u:%g" $in | str trim }

# Creates a directory (mode 700) containing a file (mode 600) and a sub-directory (mode 700)
def setup []: nothing -> record {
    let dir = bf fs make_temp_dir
    let file = $"($dir)/file"
    let sub = $"($dir)/sub"
    "" | save $file
    mkdir $sub
    ^chmod 600 $file
    ^chmod 700 $sub $dir
    {dir: $dir, file: $file, sub: $sub}
}


#======================================================================================================================
# apply_file
#======================================================================================================================

export def apply_file__applies_owner_and_file_and_directory_modes [] {
    let x = setup
    let ch_d = mktemp
    $"($x.dir) 1234:1234 640 750" | save --force $ch_d

    apply_file $ch_d

    assert equal "1234:1234" ($x.file | ids)
    assert equal "640" ($x.file | mode)
    assert equal "750" ($x.sub | mode)
}

export def apply_file__finds_file_in_ch_d_directory [] {
    let x = setup
    let ch_d = mktemp --directory
    $"($x.dir) 1234:1234 640 750" | save $"($ch_d)/10-test"

    with-env {BF_ETC_CH_D: $ch_d} { apply_file "10-test" }

    assert equal "640" ($x.file | mode)
}
