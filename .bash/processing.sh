# These are utility functions to make working with
# https://github.com/processing/processing/ more enjoyable.

# Sets up new processing sketch project.
pnew() {
  if [ $# -eq 1 ]; then
    mkdir $1
    touch $1/$1.pde
  else
    echo 'Missing sketch name'
  fi
}

# Runs processing sketch. Assumes you are in the parent directory of the
# project.
prun() {
  if [ $# -eq 1 ]; then
    processing-java --sketch=`pwd`/$1 --force --run
  else
    echo 'Missing sketch name'
  fi
}
