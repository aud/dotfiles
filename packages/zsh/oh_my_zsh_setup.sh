#!/bin/bash

install_zsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

setup_zsh_theme() {
  #theme setup stuff
}

begin() {
  install_zsh
}

begin "$@"
