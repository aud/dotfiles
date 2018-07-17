# Aliases for common dev commands.
alias rsa="railgun status -a -H -o name | xargs -n1 railgun stop"
alias dc="dev cd"
alias dd="dev down"
alias du="dev up"
alias dj="dev up; dev s"

# Aliases for commonly used general commands.
alias c="clear"
alias ls="ls -G"

# Alias vi to vim.
alias vi="/usr/local/bin/vim"

# This alias should be better. Doesn't need to be direct path, also this
# doesn't support the `cd` protocol. Also will likely be unnecessary once full
# Go module support is released.
alias gopath="$GOPATH/src/github.com/aud"
