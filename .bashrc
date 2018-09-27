# Load dev.sh if shell is interactive.
if [[ -f /opt/dev/dev.sh ]] && [[ $- == *i* ]]; then
  source /opt/dev/dev.sh
fi

# Source all files in ~/.bash, assume they are executable.
for file in ~/.bash/*; do
  source $file
done

# Hack to set default ruby version.
chruby 2.5.0

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

# Source fzf.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
