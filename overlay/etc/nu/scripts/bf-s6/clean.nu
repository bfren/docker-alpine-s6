use bf

# clean src directory
export def src [] {
    let dir = bf env ETC_SRC
    bf write debug $"Cleaning ($dir)." clean/src
    bf del force $"($dir)/*"
}
