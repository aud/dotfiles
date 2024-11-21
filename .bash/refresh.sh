refresh() {
  set -x

  brew update
  brew upgrade
  brew cleanup

  nvim --headless "+Lazy! sync" +qa

  set +x
}
