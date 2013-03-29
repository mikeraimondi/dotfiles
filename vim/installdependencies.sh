#!/bin/bash
############################
# .make.sh
# This script installs dependencies for vim and plugins
############################

# Variables
tempdir=/tmp/dotfiles

# install apt packages and build if on Linux
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	# Make sure only root can run our script
	if [[ $EUID -ne 0 ]]; then
		 echo "This script must be run as root" 1>&2
		 exit 1
	fi

	echo "Installing packages"
	apt-get update && apt-get install aptitude
	aptitude -y install git mercurial tmux ncurses-dev python-dev python-pip cmake build-essential python-psutil
	pip install -U psutil
	echo "..done"

	# build libgit2
	echo "Building libgit2"
	export LD_RUN_PATH=/usr/local/lib #required so Python can access libgit2
	mkdir -p $tempdir
	cd $tempdir
	if [ ! -d "libgit2" ]; then
		git clone https://github.com/libgit2/libgit2.git
	fi
	cd libgit2
	git pull
	mkdir -p build
	cd build
	cmake ..
	cmake --build .
	cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local
	cmake --build . --target install
	echo "..done"

	# build pygit2
	echo "Building pygit2"
	mkdir -p $tempdir
	cd $tempdir
	if [ ! -d "pygit2" ]; then
		git clone git://github.com/libgit2/pygit2.git
	fi
	cd pygit2
	git pull
	python setup.py install
	python setup.py test
	echo "..done"

	# build Vim
	echo "Building Vim"
	mkdir -p $tempdir
	cd $tempdir
	if [ ! -d "vim" ]; then
		hg clone https://vim.googlecode.com/hg/ vim
	fi
	cd vim
	hg pull && hg update
	./configure --prefix=/usr/local --with-features=huge --enable-pythoninterp --with-python-config-dir=/usr/lib/python2.7/config --enable-gui=no
	make && make install
	echo "..done"

#install Homebrew and Pip packages if on OSX
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Installing packages"
	brew update
	brew install python mercurial git tmux cmake vim libgit2
	pip install -U psutil pygit2
	echo "..done"

fi
