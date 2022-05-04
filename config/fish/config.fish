# aliases
alias vi="vim"
alias c="code"
alias vup="vagrant up; and vagrant ssh"
alias vsh="vagrant ssh"
alias vex="vagrant suspend &; exit"
alias dk="docker"
alias dkc="docker-compose"
alias gsup="git submodule foreach git checkout master"
alias gws="git status -sb"
alias gl="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
alias gp="git push"
alias gc="git commit"
alias gca="git commit -a"
alias gco="git checkout"
alias gwd="git diff"
alias b="bass"
alias tf="terraform"
alias kl="kubectl"
alias klc="kubectx"
alias kls="kubens"

# fish-specific setup
fish_vi_key_bindings
set __fish_git_prompt_show_informative_status yes
set __fish_git_prompt_showcolorhints yes

# colorized grep
set -x GREP_OPTIONS '--color=auto'

# make libraries in /usr/local available to Python
set -x LD_RUN_PATH /usr/local/lib

# Preferred editor for local and remote sessions
if set -q SSH_CONNECTION
    set -x EDITOR vim
else
    set -x EDITOR $HOME/.editor
end
set -x BUNDLER_EDITOR $EDITOR
set -x GURNEL_EDITOR "code -w -n -a . $argv"

# Java
if test -e /usr/libexec/java_home
    set -x JAVA_HOME (/usr/libexec/java_home)
else
    set -x JAVA_HOME /usr/lib/jvm/default-java
end

# Go
if test -d $HOME/go/bin/go
    set -x PATH $PATH $HOME/go/bin
end
set -x GOPATH $HOME/Documents/projects/go
set -x PATH $PATH $GOPATH/bin
set -x PATH $PATH /usr/local/opt/go/libexec/bin

# Ruby
fish_add_path /opt/homebrew/opt/ruby/bin
fish_add_path /opt/homebrew/lib/ruby/gems/3.1.0/bin

# Rust
if test -d $HOME/.cargo/bin
    set -x PATH $PATH $HOME/.cargo/bin
end

# Fisherman
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# misc
set -g fish_user_paths /usr/local/opt/curl/bin $fish_user_paths
# TODO figure out how to make "j" work with https://github.com/fish-shell/fish-shell/blob/72d80c3d91bbd35bed0aafb5514c9834bb48e256/share/completions/j.fish
# set -U Z_CMD "j"
set -U FISH_KUBECTL_COMPLETION_TIMEOUT 2s
set -g fish_user_paths /usr/local/opt/ruby/bin $fish_user_paths
direnv hook fish | source
if test -d "$HOME/Library/Application Support/Code/User/globalStorage/ms-vscode-remote.remote-containers/cli-bin"
    set -x PATH $PATH "$HOME/Library/Application Support/Code/User/globalStorage/ms-vscode-remote.remote-containers/cli-bin"
end
