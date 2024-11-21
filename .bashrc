[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

# Source all files in ~/.bash, assume they are executable
for file in $HOME/.bash/*; do
  source $file
done

# Set default fzf command for vim to use rg instead of find
export FZF_DEFAULT_COMMAND="rg --files --hidden"

# Number of lines in history file
HISTFILESIZE=100000000

# Number of lines in history to keep in memory
HISTSIZE=1000000

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
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Gpg config
export GPG_TTY=$(tty)

# Tab autocomplete options
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'
bind 'set menu-complete-display-prefix on'
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
[[ -f "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.bash.inc" ]] && source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.bash.inc"
[[ -f "$HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh" ]] && source "$HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh"
[[ -f "$HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh" ]] && source "$HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh"
