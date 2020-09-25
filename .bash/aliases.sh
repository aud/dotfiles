# Shutdown all Railgun vms
rsa() {
  ruby $HOME/dotfiles/scripts/kill.rb
}

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

# Remove newline
alias nn="tr -d '\n'"
