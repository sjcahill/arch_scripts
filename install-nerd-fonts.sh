#!/bin/bash

# script to install some popular fonts from nerd-fonts
# repo located at https://github.com/ryanoasis/nerd-fonts

# fonts will be placed in the /usr/share/fonts directory
# script must therefore be executed as root

red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
nc='\033[0m'

echo -e "${blue} executing script ${0} ${nc}"

# sparse clone of the nerdfont github repository
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts

echo -e "${blue}adding patched fonts to our cloned sparse repo${nc}"

# adding the fonts we want to our sparse repo
$(cd nerd-fonts && git sparse-checkout add patched-fonts/CodeNewRoman)
$(cd nerd-fonts && git sparse-checkout add patched-fonts/DejaVuSansMono)
$(cd nerd-fonts && git sparse-checkout add patched-fonts/Hack)
$(cd nerd-fonts && git sparse-checkout add patched-fonts/JetBrainsMono)
$(cd nerd-fonts && git sparse-checkout add patched-fonts/Mononoki)
$(cd nerd-fonts && git sparse-checkout add patched-fonts/Noto)

echo -e "${green}successfully added the patched fonts to our sparse cloned repo${nc}"

# location to ultimately store our fonts on system - works with fontconfig
fontdir="/usr/share/fonts"

fonts=(
  "CodeNewRoman"
  "DejaVuSansMono"
  "Hack"
  "JetBrainsMono"
  "Mononoki"
  "Noto"
)


# create our font directory if dne
if [[ ! -d "${fontdir}" ]]
then
	mkdir -p "${fontdir}"
fi

# iterate through fonts and install using repo install script
# script dumps all fonts into same location so we need to move them
# and clean folder for each font for better organization
for font in "${fonts[@]}"
do

	default="${HOME}/.local/share/fonts"

	if [[ ! -d ${default} ]]
	then
		mkdir -p ${default}
	fi

	# will install fonts to $home/.local/share/fonts by default
	./nerd-fonts/install.sh "${font}"

	if [[ $? -eq 0 ]]
	then
		echo -e "${green}succesfully installed font: ${font}${nc}"
	fi

	if [[ ! -d ${fontdir}/${font} ]]
	then
		mkdir ${fontdir}/${font}
	fi

	$(mv "${default}/NerdFonts"/* ${fontdir}/${font}/)
	$(rm -rf "${default}/NerdFonts")

done

if [[ -d "nerd-fonts" ]]
then
  $(rm -rf nerd-fonts)
fi

echo -e "${BLUE}Completed installing all wanted fonts: ${fonts[@]}${NC}"

