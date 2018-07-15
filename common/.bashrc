# Load dev.sh if shell is interactive.
if [[ -f /opt/dev/dev.sh ]] && [[ $- == *i* ]]; then
  source /opt/dev/dev.sh
fi

# Fetch current branch name and wrap in parenthesis if exists.
function parsed_git_branch {
  git rev-parse --abbrev-ref HEAD 2> /dev/null | sed 's/.*/(&)/'
}

# Set prompt prefix
export PS1="\W\$(parsed_git_branch) \\$ "

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

# Hack to set default ruby version.
chruby 2.5.0

# This alias should be better. Doesn't need to be direct path, also this
# doesn't support the `cd` protocol. Also will likely be unnecessary once full
# Go module support is released.
alias gopath="$GOPATH/src/github.com/aud"

# Set default fzf command for vim to use rg instead of find.
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# Source fzf.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
