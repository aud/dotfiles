#!/bin/bash

publish() {
  # git branch-name is defined in .gitconfig

  if [ $# -eq 0 ]; then
    git push -u origin $(git branch-name);
  elif [ "${1}" == "-f" ]; then
    git push --force-with-lease origin $(git branch-name);
  else
    echo "${1} is an invalid argument!";
  fi
}

publish "$@"
