use bf

# Save an environment variable to the S6 environment
export def-env main [
    key: string # Environment variable key name - will be prefixed with 'BF_'
    value: any  # Environment variable value
] {
    # add BF_ prefix
    let use_key = $"BF_($key)"
    bf write debug $"($use_key)=($value)." env/set

    # save to current script's environment
    load-env { $use_key: $value }

    # persist to S6 environment (load scripts using /command/with-contenv or s6 x module)
    $value | save --force $"/run/s6/container_environment/($use_key)"
}

# Sets the BF_E environment variable to the name of the currently executing script
export def-env set_executable [
    prefix?: string # If set, will be added before the name of the current script
] {
    main E (if $prefix != null { $"($prefix)/" } | $"($in)($env.CURRENT_FILE | path basename)")
}
