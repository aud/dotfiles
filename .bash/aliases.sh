# Shutdown all Railgun vms
alias rsa="railgun status -a -H -o name | xargs -n1 railgun stop"

# Common
alias c="clear"
alias ls="ls -Ga"

# Overwrite default install with brew package
alias ctags="/usr/local/bin/ctags"
alias vi="/usr/local/bin/vim"

# Default ruby
alias ruby="/opt/rubies/2.6.1/bin/ruby"

# Default to xterm with ssh
alias ssh='TERM=xterm ssh'
