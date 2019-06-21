# Shutdown all Railgun vms
alias rsa="railgun status -a -H -o name | xargs -n1 railgun stop"

# Common
alias c="clear"
alias ls="ls -Ga"

# Extend git with https://github.com/github/hub
eval "$(hub alias -s)"

# Overwrite default install with brew package
alias ctags="/usr/local/bin/ctags"

# Use neovim instead
alias vi="/usr/local/bin/nvim"
alias vim="/usr/local/bin/nvim"

# Default ruby
# alias ruby="/opt/rubies/2.6.3/bin/ruby"

# Default to xterm with ssh
alias ssh='TERM=xterm ssh'
