# aliases
alias vi="vim"
alias c="code"
alias gsup="git submodule foreach git checkout master"
alias vup="vagrant up; and vagrant ssh"
alias vsh="vagrant ssh"
alias vex="vagrant suspend &; exit"
alias dk="docker"
alias dkc="docker-compose"
alias crl="/usr/local/Cellar/curl/7.47.0/bin/curl"
alias ossl="/usr/local/Cellar/openssl/1.0.2f/bin/openssl"

# fish-specific setup
fish_vi_key_bindings

# colorized grep
set -x GREP_OPTIONS '--color=auto'

# make libraries in /usr/local available to Python
set -x LD_RUN_PATH /usr/local/lib

# Preferred editor for local and remote sessions
if set -q SSH_CONNECTION
  set -x EDITOR 'vim'
else
  set -x EDITOR $HOME/.editor
end
set -x BUNDLER_EDITOR $EDITOR
set -x GURNEL_EDITOR $HOME/.gurnel_editor

# Java
if test -d /usr/libexec/java_home
	set -x JAVA_HOME /usr/libexec/java_home
else
	set -x JAVA_HOME /usr/lib/jvm/default-java
end

# Go
if test -d $HOME/go/bin/go
 set -x PATH $PATH $HOME/go/bin
end
set -x GOPATH $HOME/GDrive/go_projects
set -x PATH $PATH $GOPATH/bin
set -x PATH $PATH /usr/local/opt/go/libexec/bin

# Rust
if test -d $HOME/.cargo/bin
  set -x PATH $PATH $HOME/.cargo/bin
end
set -x RUST_SRC_PATH $HOME/.multirust/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src

# Nodenv & Rbenv
status --is-interactive; and source (nodenv init -|psub)
status --is-interactive; and source (rbenv init -|psub)

# ITerm integration
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
