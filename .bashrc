# Source all files in ~/.bash, assume they are executable.
for file in $HOME/.bash/*; do
  . $file
done

# Set default fzf command for vim to use rg instead of find.
export FZF_DEFAULT_COMMAND='rg --files --follow --hidden --glob "!.git/*"'

# Remove duplicate entries in history file.
export HISTCONTROL=ignoreboth:erasedups

# Number of lines in history file.
export HISTFILESIZE=50000

# Number of lines in history to keep in memory.
export HISTSIZE=10000

export GOPATH=$HOME

# Add golang to PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$GOPATH/bin:$PATH

# Tab autocomplete options
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'
bind 'set menu-complete-display-prefix on'
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'

# Lazy load dev
__dev_hook_prompt() { :; }

__DEV_LOADED=
dev() {
  if [ ! $__DEV_LOADED ] && [ -f /opt/dev/dev.sh ]; then
    . /opt/dev/dev.sh
    __DEV_LOADED=true
  fi

  eval dev $@
}

chruby() {
  command -v chruby >/dev/null 2>&1 && . /opt/dev/sh/chruby/chruby.sh && chruby $@
}

[ -d $HOME/.bin ] && export PATH=$HOME/.bin:$PATH
[ -f ~/.fzf.bash ] && . ~/.fzf.bash
