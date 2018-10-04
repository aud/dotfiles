git() {
  if [[ $1 == 'clone' ]]; then
    command git clone "$2" && cd $(basename "$2")
  else
    command git "$@"
  fi
}
