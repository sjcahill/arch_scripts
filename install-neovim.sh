#!/usr/bin/bash

# Script to install neovim from source
# ----------

# Font colorizers
blue='\033[0;34m'
green='\033[0;32m'
nc='\033[0m'

# Remove any possible directories that contain nvim date

if [[ -d /usr/local/share/nvim ]]; then
	$(sudo rm -rf nvim)
fi

if [[ -e /usr/local/bin/nvim ]]; then
	$(sudo rm nvim)
fi

if [[ -d "{$HOME}/neovim" ]]; then
	$(sudo rm -rf "${HOME}/neovim")
fi

if [[ -d "${HOME}/Downloads/neovim" ]]; then
	$(sudo rm -rf "${HOME}/Downloads/neovim")
fi


echo -e "${blue}Cloning neovim github repository ${nc}"

git clone https://github.com/neovim/neovim "${HOME}/Downloads/neovim"

function install_neovim() {
	echo -e "${blue}Starting the Install process for Neovim${nc}"
	cd "${HOME}/Downloads/neovim" 
	git checkout stable
	rm -rf build/
	echo -e "${blue}Modifying the install directory with cmake flags${nc}"
	make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${HOME}/neovim"
	echo -e "${blue}Installing neovim with cmake${nc}"
	sudo make install
}
	

: '
$(cd "${HOME}/Downloads/neovim" &&
	git checkout stable
	rm -rf build/ &&
	echo -e "${blue}Modifying the install directory with cmake flags${nc}" &&
	make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${HOME}/neovim" &&
	echo -e "${blue}Installing neovim with cmake${nc}" &&
	sudo make install
)
'

install_neovim

echo -e "${green}Successfully built neovim from source. Should be located at: ${HOME}/neovim ${nc}"
