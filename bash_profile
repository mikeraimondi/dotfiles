#!/usr/bin/env bash

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
fi

# Add global NPM packages to path
export PATH="/usr/local/share/npm/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Load Direnv
eval "$(direnv hook $0)"

# Load common config
source "$HOME/.commonprofile"
