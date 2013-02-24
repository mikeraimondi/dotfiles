#!/bin/bash
############################
# .make.sh
# This script builds vim plugin support files
############################

# build YouCompleteMe
echo "Building YouCompleteMe"
cd ~/dotfiles/vim/bundle/YouCompleteMe
./install.sh
echo "...done"

#install powerline
echo "Installing Powerline"
pip install --user git+git://github.com/Lokaltog/powerline
echo "...done"
