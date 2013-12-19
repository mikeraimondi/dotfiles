# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
fi

# Load rbenv shims and autocompletion
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
