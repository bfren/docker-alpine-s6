use bf

# clean src directory
export def src [] {
    bf write debug $"Cleaning (bf env req SRC)." clean/src
    bf del force $"(bf env req SRC)/*"
}
