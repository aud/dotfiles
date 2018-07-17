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
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# Source fzf.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
