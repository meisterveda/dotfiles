#!/usr/bin/env bash

# Install command-line tools using Aptitude.

# Make sure we’re using the latest apt-get.
sudo apt update

# Upgrade any already-installed formulae.
sudo apt upgrade -y

# Save Aptitude installed location.


# Install some other useful utilities
sudo apt install ubuntu-restricted-extras -y
sudo apt install gnome-tweaks -y
sudo apt install apt-transport-https curl -y
sudo apt install snapd -y
sudo apt install ffmpeg -y


# Install Brave and chrome Browsers
sudo apt install google-chrome-stable -y
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

# Install zsh
sudo apt-get update
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Switch to using zsh-installed bash as default shell
# if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
#   echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
#   chsh -s "${BREW_PREFIX}/bin/bash";
# fi;
chsh -s $(which zsh)

# Install nemo file explorer
sudo apt install nemo -y
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.nemo.desktop show-desktop-icons true
xdg-open $HOME


# Install snap binaries
sudo snap install spotify
sudo snap install postman
sudo snap install slack
sudo snap install gitkraken --classic
sudo snap install bluemail
sudo snap install standard-notes
sudo snap install code --classic
sudo snap install geforcenow-electron
sudo snap install vlc
sudo snap install jdownloader2
sudo snap install vidcutter


# Install Development enviroment

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install 18.10
nvm use 18.10

# Yarn
corepack enable

# Install peripheral controller
sudo apt install ratbagd -y
sudo apt install piper -y
