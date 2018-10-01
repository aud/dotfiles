# Load dev.sh if shell is interactive.
if [[ -f /opt/dev/dev.sh ]] && [[ $- == *i* ]]; then
  source /opt/dev/dev.sh
fi

# Hack to set default ruby version.
if command -v chruby >/dev/null 2>&1; then
  chruby 2.5.0 >/dev/null 2>&1
fi

# Source all files in ~/.bash, assume they are executable.
for file in ~/.bash/*; do
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

# Add golang to PATH
export PATH=$PATH:/usr/local/go/bin

# Cycle through tab autocomplete options
bind 'TAB:menu-complete'
bind 'set menu-complete-display-prefix on'
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'

# Source fzf.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
