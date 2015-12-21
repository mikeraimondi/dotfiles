#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Needed for git HEAD^
setopt NO_NOMATCH

# Vi mode config
export KEYTIMEOUT=1 # Turn off lag when changing Vi mode

# Direnv
eval "$(direnv hook zsh)"

source_sh () {
  emulate -LR sh
  . "$@"
}

# Load common config
source_sh $HOME/.commonprofile

# iTerm shell integration
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# The next line updates PATH for the Google Cloud SDK.
test -e $HOME/.bin/google-cloud-sdk/path.zsh.inc && source ${HOME}/.bin/google-cloud-sdk/path.zsh.inc

# The next line enables shell command completion for gcloud.
test -e $HOME/.bin/google-cloud-sdk/completion.zsh.inc && source ${HOME}/.bin/google-cloud-sdk/completion.zsh.inc

# AWS CLI shell command completion
test -e /usr/local/share/zsh/site-functions/_aws && source /usr/local/share/zsh/site-functions/_aws
