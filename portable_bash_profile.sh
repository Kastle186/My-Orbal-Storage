# My Portable Bash Profile!

# My goodness the Ctrl-S freeze shortcut is so annoying. So, disabling it with
# this, as I have no use for it.

stty -ixon

# While I'm fairly comfortable with the defaults of Bash, I have my tastes regarding
# certain commands, aliases, and most importantly: Visual Looks! So, I keep here the
# small pieces of customization to have Bash just like I like it :)

# My custom prompt!

export PS1="\n\[\e[1;38;5;043m\]\w\[\e[38;5;220m\] > \[\e[0m\]"

# Add color to ls and the grep's by default, as well as limit ls output to only
# up to 100 characters per line. This is so that it's more easily readable, and
# allows for terminal splitting while keeping good formatting.

alias ls='ls --color=auto --width=100'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

function ncd()
{
    local path=""

    for (( i=1; i<=$1; i++ )); do
        path="../$path"
    done

    cd "$path"
}
