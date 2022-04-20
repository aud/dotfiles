#!/usr/bin/env bash

set -eux

if [ $SPIN ]; then
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt-get update -y
  sudo apt-get install -y \
    neovim \
    ripgrep

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

  alias vi="nvim"
  alias vim="nvim"
  alias c="clear"
  alias ls="ls -Ga"

  mkdir -p $HOME/.config/nvim
  ln -sf $HOME/dotfiles/.config/nvim/init.vim $HOME/.config/nvim/init.vim
fi
