#!/bin/bash

setup_autocomplete() {
  echo "Setting up Zsh autocomplete..."
  git clone git://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
  echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
}

begin() {
  setup_autocomplete
}

begin "$@"
