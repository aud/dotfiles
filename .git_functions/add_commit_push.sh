#!/bin/bash

add_or_push_with_commits() {
  # git branch-name is defined in .gitconfig

  if [ "${1}" == "-p" ] && [ "${2}" == "-m" ]; then
    git add -A && git commit -m "${3}" && git push -u origin $(git branch-name);
  elif [ "${1}" == "-m" ] && [ "${3}" == "-p" ]; then
    git add -A && git commit -m "${2}" && git push -u origin $(git branch-name);
  elif [ "${1}" == "-mp" ] || [ "${1}" == "-pm" ]; then
    git add -A && git commit -m "${2}" && git push -u origin $(git branch-name);
  elif [ "${1}" == "-m" ] && [ $# == 2 ]; then
    git add -A && git commit -m "${2}";
  else
    echo "Invalid arguments. Valid commands are:

      Add all, commit with message, push to current branch.
        - git ac -m 'message' -p
        - git ac -mp 'message'
        - git ac -p -m 'message'
        - git ac -pm 'message'

      Add all and commit with message.
        - git ac -m 'message'
    ";
  fi
}

add_or_push_with_commits "$@"
