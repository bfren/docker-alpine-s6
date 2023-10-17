use bf

# Save an environment variable to the S6 environment
export def-env main [
    key: string # Environment variable key name - the BF_ prefix will be added automatically
    value: any  # Environment variable value
] {
    # add the BF_ prefix
    let prefixed = $"BF_($key)"

    # save to current script's environment
    load-env { $prefixed: $value }

    # persist to S6 environment (load scripts using /command/with-contenv or s6 x module)
    $value | save --force $"/run/s6/container_environment/($prefixed)"

    # output for debugging purposes
    bf write debug $"($prefixed)=($value)." env/set
}

# Sets the BF_E environment variable to the name of the currently executing script
export def-env set_executable [
    prefix?: string # If set, will be added before the name of the current script
] {
    main E (bf env get_executable $prefix)
}
