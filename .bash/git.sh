# Bash alias don't support spaces, and default git commands cannot be realiased
# in gitconfig. This is to set `git commit` to be verbose by default.
function git {
  if [[ $1 == "commit" ]]; then
    command git commit --verbose
  else
    command git "$@"
  fi
}
