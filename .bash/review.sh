function review {
  local branch="${1:-$git branch-name}"
  local base="${2:-master}"

  # If for some reason the branch doesn't exist on remote.
  if ! git fetch origin $base $branch >/dev/null 2>&1; then
    echo "Couldn't find remote ref for branch: $branch"
    return 1
  fi

  # If project has dev.yml and the vm is not currently running.
  if test -f "dev.yml" && ! railgun status -H -o name >/dev/null 2>&1; then
    dev up
  fi

  vim -p $(git diff --name-only origin/$base...origin/$branch) -c "tabdo :Gdiff origin/$branch" -c "tabfirst"
}
