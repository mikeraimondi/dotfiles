#!/bin/bash
############################
# .make.sh
# This script installs dependencies for vim and plugins
############################

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install apt packages
echo "Installing packages"
aptitude -y install git mercurial tmux ncurses-dev python-dev python-pip cmake
echo "..done"

# build Vim
echo "Building Vim"
mkdir /tmp/dotfiles
cd /tmp/dotfiles
hg clone https://vim.googlecode.com/hg/ vim
cd /tmp/dotfiles/vim
./configure --with-features=huge --enable-pythoninterp --with-python-config-dir=/usr/lib/python2.7/config
make && make install
