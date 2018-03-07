#!/bin/bash

check_for_brew() {
  echo "Checking for brew..."
  if test ! $(which brew); then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

check_for_cask() {
  echo "Tapping brew cask..."
  if ! brew tap | grep -q caskroom; then
    brew tap caskroom/cask 1>/dev/null
    brew tap caskroom/versions 1>/dev/null
  fi
}

update() {
  echo "Updating brew..."
  brew update
}

install_packages() {
  for pkg in mysql node redis ruby-install wget; do
    echo "Installing '${pkg##*\/}'"
    brew install $pkg -v 1>/dev/null
  done
}

install_casks() {
  for pkg in iterm2 google-chrome spotify; do
    check_if_cask_exists "${pkg}"
  done
}

check_if_cask_exists() {
  echo "$1"
  for arg in "$1"; do
    if find '/Applications' | grep "${arg}"; then
      echo "${arg} is already installed! Skipping..."
    else
      echo "Installing '${arg##*\/}'..."
      brew cask install -v --appdir="/Applications" $arg 1>/dev/null
    fi
  done
}

begin() {
  check_for_brew && update && check_for_cask
  install_packages
  install_casks
}

begin "$@"
