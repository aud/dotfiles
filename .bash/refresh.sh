execute_with_progress() {
  __PRINTED=
  __DOT="."

  # Start background process that outputs every 0.05s.
  (while true; do
    for c in '-' '/' '|' '\'; do
      if [ ! $__PRINTED ]; then
        __PRINTED=true
        printf "%b" "\e[1;34mRunning '$1'\e[0m  "
      else
        printf "\b$c"
        sleep 0.05
      fi
    done
  done) &

  # Execute command.
  $1

  # Kill PID once command is complete.
  kill $! && wait $! 2>/dev/null && echo -n
}

refresh() {
  execute_with_progress "brew update"
  execute_with_progress "brew upgrade"
  execute_with_progress "brew cleanup"
  execute_with_progress "nvim --headless +PlugClean! +qall"
  execute_with_progress "nvim --headless +PlugUpgrade +qall"
  execute_with_progress "nvim --headless +PlugUpdate +qall"

  echo "done"
}
