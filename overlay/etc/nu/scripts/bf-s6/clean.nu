use bf

# clean src directory
export def src []: nothing -> nothing {
    let dir = bf env ETC_SRC
    bf write debug $"Cleaning ($dir)." clean/src
    $"($dir)/*" | into glob | rm --force --recursive $in
}
