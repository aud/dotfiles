# Source all files in ~/.bash, assume they are executable.
for file in $HOME/.bash/*; do
  source $file
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

[ -d $HOME/.bin ] && export PATH=$HOME/.bin:$PATH
[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
