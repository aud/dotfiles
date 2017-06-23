#!/bin/bash

echo "Setting up your profile..."

# Sudo continious keep alive
echo "Sudo access is required in order to set system configs, and install some brew packages. To see specifics, see '.system' and 'packages/homebrew.sh'"

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

for s in setup.sh .system; do source $s; done

echo "Done!"