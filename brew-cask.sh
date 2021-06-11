#!/bin/bash

echo "Make sure HOMEBREW_CASK_OPTS is set before continuing..."
read -p "Is it set? (y/n)" resp

if [ $resp != "y" -a $resp != "Y" ]; then
	echo "exiting..."
	exit 0
fi


# to maintain cask ....
#     brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup`


# Install native apps

# brew install caskroom/cask/brew-cask
# brew tap caskroom/versions

# daily
# brew install --cask alfred
brew install --cask spectacle
# brew install --cask dropbox
brew install --cask gyazo
# brew install --cask authy
brew install --cask rescuetime
# brew install --cask flux
brew install --cask spotify
brew install --cask google-backup-and-sync
brew install --cask google-drive-file-stream # for organizational drive syncing, i.e. Conde
# brew install --cask zoomus


# dev
# brew install --cask atom
brew install --cask iterm2
brew install --cask imagealpha
brew install --cask imageoptim
# brew install --cask insomnia
brew install --cask ngrok
brew install --cask p4v
brew install --cask postman
brew install --cask nosqlclient
brew install --cask rowanj-gitx
brew install --cask sequel-pro
# brew install --cask sublime-text
# brew install --cask vagrant
# brew install --cask virtualbox
brew install --cask visual-studio-code
brew install --cask docker
brew install --cask pgadmin4

# fun
# brew install --cask limechat
# brew install --cask miro-video-converter
# brew install --cask horndis               # usb tethering

# browsers
# brew install --cask google-chrome
# brew install --cask google-chrome-canary
# brew install --cask firefox
# brew install --cask firefoxnightly
# brew install --cask webkit-nightly
# brew install --cask chromium
# brew install --cask torbrowser

# less often
# brew install --cask android-file-transfer
brew install --cask appcleaner
brew install --cask beardedspice
brew install --cask evernote
brew install --cask recordit
# brew install --cask skitch
# brew install --cask disk-inventory-x
# brew install --cask screenflow
brew install --cask vlc
# brew install --cask gpgtools
# brew install --cask licecap
# brew install --cask utorrent

# fonts!
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
brew install --cask font-ibm-plex
brew install --cask font-inconsolata
brew install --cask font-source-code-pro

# Remove outdated versions from the cellar
# @NOTE: comment out if you want to keep older versions
brew cleanup

