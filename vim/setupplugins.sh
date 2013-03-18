#!/bin/bash
############################
# .make.sh
# This script builds vim plugin support files
############################

# update submodules
cd ~/dotfiles
git submodule init && git submodule update

# build YouCompleteMe
echo "Building YouCompleteMe"
cd ~/dotfiles/vim/bundle/YouCompleteMe
./install.sh
echo "...done"

# install powerline
echo "Installing Powerline"
pip install --user -U git+git://github.com/Lokaltog/powerline
echo "...done"
