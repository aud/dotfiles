#!/bin/bash

install_packages() {
  bash packages/homebrew/homebrew.sh
  bash packages/iterm/iterm.sh
}

begin() {
  install_packages
}

begin "$@"