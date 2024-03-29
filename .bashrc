[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

# Source all files in ~/.bash, assume they are executable
for file in $HOME/.bash/*; do
  source $file
done

# Set default fzf command for vim to use rg instead of find
export FZF_DEFAULT_COMMAND='rg --files --hidden'

# Remove duplicate entries in history file
HISTCONTROL=ignoreboth:erasedups

# Number of lines in history file
HISTFILESIZE=1000000

# Number of lines in history to keep in memory
HISTSIZE=100000

# Ignore common commands from history
HISTIGNORE="&:[ ]*:exit:ls:fg:bg:tmux:vi:vim:c:clear*"

# Append to history instead of clobbering on exit
shopt -s histappend

# Append to history post command and reread
PROMPT_COMMAND="history -a; history -n;${PROMPT_COMMAND:-:}"

# Congiure default editor
export EDITOR=nvim

# Disable spring
export DISABLE_SPRING=1

# Configure PATH
export GOPATH=$HOME
export CDN_PATH=$HOME/x/cmd/x
export DEFAULT_RUBY_PATH=/opt/rubies/2.7.1/bin
export GIT_ALIAS_PATH=$HOME/.git-aliases

export PATH=$GOPATH:$DEFAULT_RUBY_PATH:$CDN_PATH:$GIT_ALIAS_PATH:$PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/opt/libxml2/lib/pkgconfig:/usr/local/opt/libffi/lib/pkgconfig

# Android PATH
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Gpg config
export GPG_TTY=$(tty)

# cloudplatform: add Shopify clusters to your local kubernetes config
export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}/Users/elliotdohm/.kube/config:/Users/elliotdohm/.kube/config.shopify.cloudplatform

# Tab autocomplete options
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'
bind 'set menu-complete-display-prefix on'
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'

# Lazy load dev
__DEV_LOADED=
dev() {
  if [ ! $__DEV_LOADED ] && [ -f /opt/dev/dev.sh ]; then
    source /opt/dev/dev.sh
    __DEV_LOADED=true
  fi

  dev $@
}

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source "$(brew --prefix)/share/google-cloud-sdk/path.bash.inc"

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && { type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; } }
