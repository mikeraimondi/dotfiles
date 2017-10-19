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

# fish-specific setup
fish_vi_key_bindings
set __fish_git_prompt_show_informative_status 'yes'
set __fish_git_prompt_showcolorhints 'yes'

function fish_prompt --description "Write out the prompt"
    set -l color_cwd
    set -l suffix
    switch $USER
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '>'
    end

    echo -n -s (__fish_git_prompt) ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal) "$suffix "
end

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
set -x GURNEL_EDITOR "code -w -n -a . $argv"

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
set -x GOPATH $HOME/Documents/projects/go
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

# misc
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
eval (direnv hook fish)

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/mike/.nodenv/versions/8.1.2/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish ]; and . /Users/mike/.nodenv/versions/8.1.2/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/mike/.nodenv/versions/8.1.2/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish ]; and . /Users/mike/.nodenv/versions/8.1.2/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish
