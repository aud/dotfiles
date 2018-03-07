#!/bin/bash

install_packages() {
  bash packages/homebrew.sh
}

begin() {
  install_packages
}

begin "$@"
