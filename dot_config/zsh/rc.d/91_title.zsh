# Custom terminal window title handling


# Sets the terminal title to
#   user@host: pwd
# when at the prompt
function precmd_term_title() {
    print -nP -u2 "\033]0;%n@%m: %3~\007"
}

precmd_functions+=( precmd_term_title )


# Sets the terminal title to
#   user@host$ command
# when running a command
function preexec_term_title() {
    input=(${=2})
    print -nP -u2 "\033]0;%n@%m\$ ${${input[1]}[1,16]}\007"
}

preexec_functions+=( preexec_term_title )

