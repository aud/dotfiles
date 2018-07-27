# Renames tmux window to current working directory name.
function rename_tmux_window_to_wd {
  local last_pwd=''

  if [[ $TERM == 'tmux-256color' && $PWD != $last_pwd ]]; then
    last_pwd=$PWD
    tmux rename-window ${PWD//*\//}
  fi
}

export PROMPT_COMMAND="rename_tmux_window_to_wd;${PROMPT_COMMAND:-:}"
