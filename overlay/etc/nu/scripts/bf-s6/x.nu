use bf

# Run something as another user, importing the full environment beforehand
export def as [
    user: string    # Username to execute as
    ...args         # Program to execute (arguments must be quoted or you will get an error from nu)
] {
    if ($args | length) == 0 { bf write error "You must pass a program to execute." x/as }
    ^exec su $user -c $"bf-withenv $($args | str join ' ')"
}
