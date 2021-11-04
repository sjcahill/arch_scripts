#!/bin/bash

# Script to install some popular fonts from Nerd-Fonts
# Repo located at https://github.com/ryanoasis/nerd-fonts

# Fonts will be placed in the /usr/share/fonts directory
# Script must therefore be executed as root

echo "Executing script ${0}"

# Sparse clone of the NerdFont github repository
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git

echo "Adding patched fonts to our cloned sparse repo"

# Adding the fonts we want to our sparse repo
$(cd nerd-fonts && git sparse-checkout add patched-fonts/CodeNewRoman)
$(cd nerd-fonts && git sparse-checkout add patched-fonts/DejaVuSansMono)
$(cd nerd-fonts && git sparse-checkout add patched-fonts/Hack)
$(cd nerd-fonts && git sparse-checkout add patched-fonts/JetBrainsMono)
$(cd nerd-fonts && git sparse-checkout add patched-fonts/Mononoki)
$(cd nerd-fonts && git sparse-checkout add patched-fonts/Noto)

echo 'Successfully added the patched fonts to our sparse cloned repo'

# Location to ultimately store our fonts on system - works with fontconfig
FONTDIR="/usr/share/fonts"

fonts=(
  "CodeNewRoman"
  "DejaVuSansMono"
  "Hack"
  "JetBrainsMono"
  "Mononoki"
  "Noto"
)


# Create our font directory if DNE
if [[ ! -d "${FONTDIR}" ]]
then
	mkdir -p "${FONTDIR}"
fi

# Iterate through fonts and install using repo install script
# Script dumps all fonts into same location so we need to move them
# and clean folder for each font for better organization
for font in "${fonts[@]}"
do

	default="$HOME/.local/share/fonts"

	if [[ ! -d $default ]]
	then 
		mkdir -p $default
	fi

	# Will install fonts to $HOME/.local/share/fonts by default
	./nerd-fonts/install.sh "${font}"

	if [[ $? -eq 0 ]]
	then 
		echo "Succesfully installed font: ${font}"
	fi
	
	if [[ ! -d $FONTDIR/$font ]]
	then 
		mkdir ${FONTDIR}/${font}
	fi

	$(mv "${default}/NerdFonts"/* ${FONTDIR}/${font}/)
	$(rm -rf "${default}/NerdFonts")

done

echo "Completed installing all wanted fonts: "${fonts[@]}"

exit