#!/usr/bin/env bash

set -euo pipefail

echo "installing dotfiles.."

if [[ $SPIN ]]; then
  echo "symlinking.."

  for file in .[^.]*; do
    from="$(pwd)/$file"
    to="$HOME/$(basename $file)"

    # Don't symlink .git
    if [[ $file == ".git" ]]; then
      continue
    fi

    set -x
    ln -sf $from $to
    set +x
  done

  echo "installing deps.."

  if ! command -v rg &> /dev/null; then
    sudo apt-get install -y ripgrep
  fi

  if ! command -v htop &> /dev/null; then
    sudo apt-get install -y htop
  fi

  if ! command -v nvim &> /dev/null; then
    sudo apt-get install -y neovim
  fi
else
  if ! command -v brew >/dev/null 2>&1; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  if test -f 'Brewfile' && command -v brew bundle check >/dev/null 2>&1; then
    brew bundle
  fi

  source './symlink.sh'
  source './.bashrc'
  source './.system'
fi

echo "done!"
