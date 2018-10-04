# FIXME: Expensive to run brew bundle check everytime bashrc is loaded.
if test -f '.Brewfile' && command -v brew bundle check >/dev/null 2>&1; then
  brew bundle
fi
