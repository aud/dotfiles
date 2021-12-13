# If target file exists, unlink.
symlink() {
  ln -sfh $1 $2
}

file_match() {
  cmp --silent $1 $2
}

dir_match() {
  diff -r                \
    --exclude=autoload   \
    --exclude=.vim       \
    --exclude=.netrwhist \
    --exclude=plugged  $1 $2
}

symlink_exists() {
  readlink $1 == $2 >/dev/null
}

begin() {
  for file in .[^.]*; do
    local path="$(pwd)/$file"
    local base=$(basename $file)
    local target="$HOME/$base"

    # Don't symlink .git
    if [[ $file == ".git" ]]; then
      continue
    fi

    if test -h $target && symlink_exists $target $path; then
      echo "$base is already symlinked."
    elif test -f $target && file_match $path $target || dir_match $path $target; then
      echo "$base is identical to the existing file. Overriding with symlink."

      symlink $path $target
    elif [[ -a $target ]]; then
      read -p "$base differs from the existing file. Override? [yn] " choice

      case "$choice" in
        y|Y ) symlink $path $target;;
      esac
    else
      echo "$base does not exist. Symlinking to dotfile."
      symlink $path $target
    fi
  done
}

begin "$@"
