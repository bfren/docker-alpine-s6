use bf

# Apply ownership and permissions using a ch.d file - each line is: path owner [file-mode] [directory-mode]
export def apply_file [
    file: string    # Path to ch.d file - if the file does not exist, will look in ch.d directory instead
]: nothing -> nothing {
    # if file is not a path that exists, prepend CH_D directory
    let path = if ($file | path exists) { $file } else { $"(bf env ETC_CH_D)/($file)" }

    # check file exists
    if ($path | bf fs is_not_file) {
        bf write notok $"($path) does not exist or is not a file." ch/apply_file
        return
    }

    # split by row and apply changes row by row
    bf write $"Applying ($path)." ch/apply_file
    open $path
        | from ssv --minimum-spaces 1 --noheaders
        | each {|x| $x | values | bf ch apply }

    # return nothing
    return
}
