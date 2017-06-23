#!/bin/bash

install_packages() {
  bash packages/homebrew.sh
}

symlink_subl() {
  echo "Setting up Sublime symlink..."
  ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
  export EDITOR='subl -w'
}

begin() {
  install_packages
  symlink_subl
}

begin "$@"
