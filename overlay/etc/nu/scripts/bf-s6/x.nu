use bf

# Run something as another user, importing the full environment beforehand
export def as [
    user: string    # Username to execute as
    ...args         # Program to execute (arguments must be quoted or you will get an error from nu)
] {
    # check arguments first
    if $user == "" { bf write error "You must provide a user." x/as }
    if ($args | length) == 0 { bf write error "You must pass a program to execute." x/as }

    # execute $args as specified user, loading environment first
    ^exec s6-setuidgid $user bf-withenv ($args | str join ' ')
}
