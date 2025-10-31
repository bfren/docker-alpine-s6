use std assert
use ../bf-s6 clean *


#======================================================================================================================
# src
#======================================================================================================================

export def src__cleans_contents_of_src_directory [] {
    let tmpdir = mktemp --directory
    mktemp --directory --tmpdir-path $tmpdir
    random chars | save --force $"($tmpdir)/(random chars)"

    let result = with-env {BF_ETC_SRC: $tmpdir} { src } | ls $tmpdir | length
    let expect = 0

    assert equal $expect $result "src does not clean src directory"
}
