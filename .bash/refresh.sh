refresh() {
  set -x

  brew update
  brew upgrade
  brew cleanup

  nvim --headless +PlugClean! +qall
  nvim --headless +PlugUpgrade +qall
  nvim --headless +PlugUpdate +qall

  set +x
}
