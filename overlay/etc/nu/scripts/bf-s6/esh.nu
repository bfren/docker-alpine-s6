use bf

# Generate a file using an esh template in the bf templates directory:
#   - the template must have the same name as $output plus '.esh', e.g. /etc/app/app.conf uses app.conf.esh
#   - the $output directory must already exist
export def template [
    output: string  # Absolute path to the output file
]: nothing -> string {
    # get filenames and paths
    let filename = $output | path basename
    let output_dir = $output | path dirname
    let input = $"(bf env ETC_TEMPLATES)/($filename).esh"

    # ensure input file and output directory exist
    if ($input | bf fs is_not_file) { bf write error $"Template file ($input) does not exist." esh/template }
    if ($output_dir | bf fs is_not_dir) { bf write error $"Output directory ($output_dir) does not exist." esh/template }

    # output debug message and generate file
    bf write debug $" .. ($filename).esh" esh/template
    bf esh $input $output
}
