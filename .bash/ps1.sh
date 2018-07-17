# Fetch current branch name and wrap in parenthesis if exists.
function parsed_git_branch {
  git rev-parse --abbrev-ref HEAD 2> /dev/null | sed 's/.*/(&)/'
}

# Git commands extracted from:
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
function branch_state_to_prompt_color {
  local untracked=""
  local unstaged=""
  local staged=""
  local __ps1_git_status_color=""

  local debug=1

  git diff --no-ext-diff --quiet || unstaged=1
  git diff --no-ext-diff --cached --quiet || staged=1

  if git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' >/dev/null 2>/dev/null; then
    untracked=1
  fi

  # TODO: Build prompt
  if [[ $unstaged ]]; then
    __ps1_git_status_color=''
  elif [[ $untracked ]]; then
    __ps1_git_status_color=''
  elif [[ $staged ]]; then
    __ps1_git_status_color=''
  else
    __ps1_git_status_color=''
  fi

  if [[ $debug ]]; then echo $__ps1_git_status_color; fi
}

# Set prompt prefix
export PS1="\W\[\033[33m\]\$(parsed_git_branch)\[\033[00m\] \$ "
