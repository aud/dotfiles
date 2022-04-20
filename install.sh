#!/usr/bin/env bash

set -eux

if [ $SPIN ]; then
  # Some spin services already ready and fail if we run too early
  sleep 60

  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt-get update -y
  sudo apt-get install -y \
    neovim \
    ripgrep

  alias vi="nvim"
  alias vim="nvim"
  alias c="clear"
  alias ls="ls -Ga"

  mkdir -p $HOME/.config/nvim
  ln -sf $HOME/dotfiles/.config/nvim/init.vim $HOME/.config/nvim/init.vim

  for file in .[^.]*; do
    from="$(pwd)/$file"
    to="$HOME/$(basename $file)"

    # Don't symlink .git
    if [ $file == ".git" ]; then
      continue
    fi

    echo "Symlinking $from to $to"
    ln -sf $from $to
  done
fi
