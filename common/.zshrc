# Path to your oh-my-zsh installation.
export ZSH=/Users/elliotdohm/.oh-my-zsh

ZSH_THEME="spaceship"

SPACESHIP_BATTERY_SHOW=false
SPACESHIP_PROMPT_SYMBOL="$"
SPACESHIP_PROMPT_DEFAULT_PREFIX=""
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_GIT_STATUS_SHOW=false
SPACESHIP_GIT_SUFFIX=") "
SPACESHIP_GIT_PREFIX="git:("
SPACESHIP_GIT_SYMBOL="\0"
SPACESHIP_GIT_BRANCH_PREFIX=""
SPACESHIP_GIT_BRANCH_SUFFIX=""
SPACESHIP_RUBY_SHOW=false
SPACESHIP_EXEC_TIME_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_GOLANG_SHOW=false
SPACESHIP_PACKAGE_SHOW=false

alias rsa="railgun status -a -H -o name | xargs -n1 railgun stop"
alias dc="dev cd"
alias c="clear"
alias dd="dev down"
alias du="dev up"
alias dj="dev up; dev s"
alias vi="/usr/local/bin/vim"

# https://github.com/robbyrussell/oh-my-zsh/issues/433
alias rake='noglob rake'

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
plugins=(zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source ~/.bash_profile

# Must be after sourcing bashprofile
alias gopath="$GOPATH/src/github.com/aud"

# Hack to set default ruby version
chruby 2.5.0

# Source: https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# For dev golang
# export PATH=$GOPATH/bin:$PATH

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

source "/Users/elliotdohm/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
source /Users/elliotdohm/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
