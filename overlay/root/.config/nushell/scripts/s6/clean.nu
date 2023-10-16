use bf

# clean src directory
export def src [] {
    bf write debug $"cleaning ($env.BF_SRC)." clean/src
    bf del force $"($env.BF_SRC)/*"
}
