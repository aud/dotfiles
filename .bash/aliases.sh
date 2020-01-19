# Shutdown all Railgun vms
alias rsa="railgun status -a -H -o name | xargs -n1 railgun stop"

# Common
alias c="clear"
alias ls="ls -Ga"

# Overwrite default install with brew package
alias ctags="/usr/local/bin/ctags"

# Use neovim instead
alias vim="/usr/local/bin/nvim"
alias vi="/usr/local/bin/nvim"

# Default to xterm with ssh
alias ssh='TERM=xterm ssh'
