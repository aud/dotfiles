parsed_git_branch() {
  local branch=$(git branch --show-current 2>/dev/null)
  [[ -n "$branch" ]] && echo "($branch)"
}

__PS1_COLOR='\[\e[38;5;69m\]'

PS1="\W\[${__PS1_COLOR}\$(parsed_git_branch)\[\e[m\] \$ "
