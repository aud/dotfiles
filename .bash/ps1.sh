# Fetch current branch name and wrap in parenthesis if exists.
parsed_git_branch() {
  [ -d '.git' ] && echo "($(git rev-parse --abbrev-ref HEAD 2>/dev/null))"
}

__FUCHSIA_COLOR='\[\e[0;38;5;169m\]'
PS1="\W\[${__FUCHSIA_COLOR}\$(parsed_git_branch)\[\e[m\] \$ "
