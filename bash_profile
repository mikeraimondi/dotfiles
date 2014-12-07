#!/usr/bin/env bash

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
fi

# Add global NPM packages to path
export PATH="/usr/local/share/npm/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Load rbenv shims and autocompletion
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Load Direnv
eval "$(direnv hook $0)"
