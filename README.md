## Files
.vim
    directory of file type configurations and plugins
.vimrc
    my vim configuration
.screenrc
    my screen configuration
## Instructions
## Get the current clone of my dot files
   git clone git://github.com/ptsiampas/dotfiles.git ~/dotfiles

### Creating source files
Any file which matches the shell glob `_*` will be linked into `$HOME` as a symlink with the first `_`  replaced with a `.`

For example:

    _bashrc

becomes

    ${HOME}/.bashrc

### Installing source files
It's as simple as running:

    ./install.sh

From this top-level directory.

### Only install and build vim Files
Because this bit is pretty portable

    ./install.sh vim

### Restore old source Files
To replace installed files with the originals:

    ./install.sh restore

Note that if there was not an original version, the installed links will not be removed.

## Requirements
### Shell
* bash

## Other useful stuff
### Adding a new submodule (Example putting in fugitive module)

	cd ~/.vim
	mkdir ~/.vim/bundle
	git submodule add http://github.com/tpope/vim-fugitive.git bundle/fugitive
	git add .
	git commit -m "Install Fugitive.vim bundle as a submodule."
