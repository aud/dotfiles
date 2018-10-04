if test -f 'Brewfile' && command -v brew bundle check >/dev/null 2>&1; then
  brew bundle
fi
