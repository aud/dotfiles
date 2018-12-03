# Fetch current branch name and wrap in parenthesis if exists.
function parsed_git_branch {
  [ -d '.git' ] && git rev-parse --abbrev-ref HEAD 2> /dev/null | sed 's/.*/(&)/'
}

PS1="\W\[\033[33m\]\$(parsed_git_branch)\[\033[00m\] \$ "
