# Run something as another user, importing the full environment beforehand
export def as [
    user: string    # Username
    ...args         # Program / arguments to execute
] {
    ^exec su $user -c $"bf-withenv $($args)"
}
