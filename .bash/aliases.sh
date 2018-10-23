# Aliases for common dev commands.
alias rsa="railgun status -a -H -o name | xargs -n1 railgun stop"
alias dc="dev cd"
alias dd="dev down"
alias du="dev up"
alias dj="dev up; dev s"

# Aliases for commonly used general commands.
alias c="clear"
alias ls="ls -Ga"

# Alias vi to vim.
alias vi="/usr/local/bin/vim"

# Default to xterm with ssh
alias ssh='TERM=xterm ssh'
