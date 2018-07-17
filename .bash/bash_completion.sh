# Source bash completion if exists. `brew --prefix` is `/usr/local` in this
# case. `complete` to output current bindings.
if [ -f /usr/local/etc/bash_completion ]; then
  source /usr/local/etc/bash_completion
fi
