# Fetch current branch name and wrap in parenthesis if exists.
parsed_git_branch() {
  [ -d '.git' ] && echo "($(git rev-parse --abbrev-ref HEAD))"
}

PS1="\W\[\e[34m\]\$(parsed_git_branch)\[\e[m\] \$ "
