#!/usr/bin/env bash

set -euox pipefail

echo "installing dotfiles.."

if [[ $SPIN ]]; then
  echo "symlinking.."
  echo "installing deps.."
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