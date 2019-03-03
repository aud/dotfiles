# Source all files in ~/.bash, assume they are executable
for file in $HOME/.bash/*; do
  . $file
done

# Set default fzf command for vim to use rg instead of find
export FZF_DEFAULT_COMMAND='rg --files --follow --hidden --glob "!.git/*"'

# Remove duplicate entries in history file
HISTCONTROL=ignoreboth:erasedups

# Number of lines in history file
HISTFILESIZE=50000

# Number of lines in history to keep in memory
HISTSIZE=10000

# Ignore common commands from history
HISTIGNORE="&:[ ]*:exit:ls:fg:bg:tmux:vi:vim:c:clear*"

# Append to history instead of clobbering on exit
shopt -s histappend

# Append to history post command and reread
PROMPT_COMMAND="history -a; history -n;${PROMPT_COMMAND:-:}"

# Configure PATH
export GOPATH=$HOME
export CARGO_PATH=$HOME/.cargo/bin
export PATH=$CARGO_PATH:$GOPATH:$PATH

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

  dev $@
}

__CHRUBY_LOADED=
chruby() {
  if [ ! $__CHRUBY_LOADED ] && [ -f /opt/dev/sh/chruby/chruby.sh ]; then
    . /opt/dev/sh/chruby/chruby.sh
    __CHRUBY_LOADED=true
  fi

  chruby $@
}

[ -f $HOME/.fzf.bash ] && . $HOME/.fzf.bash
