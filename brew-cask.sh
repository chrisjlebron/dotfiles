#!/bin/bash


# to maintain cask ....
#     brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup`


# Install native apps

brew install caskroom/cask/brew-cask
brew tap caskroom/versions

# daily
brew cask install alfred
brew cask install spectacle
brew cask install dropbox
# brew cask install gyazo
# brew cask install authy
brew cask install rescuetime
brew cask install flux
brew cask install spotify

# dev
# brew cask install atom
brew cask install iterm2
brew cask install imagealpha
brew cask install imageoptim
brew cask install insomnia
brew cask install ngrok
brew cask install p4merge
brew cask install postman
brew cask install robomongo
brew cask install rowanj-gitx
brew cask install sequel-pro
# brew cask install sublime-text
brew cask install vagrant
brew cask install virtualbox
brew cask install visual-studio-code

# fun
# brew cask install limechat
# brew cask install miro-video-converter
# brew cask install horndis               # usb tethering

# browsers
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefox
# brew cask install firefoxnightly
# brew cask install webkit-nightly
# brew cask install chromium
# brew cask install torbrowser

# less often
brew cask install android-file-transfer
brew cask install appcleaner
brew cask install beardedspice
brew cask install evernote
brew cask install recordit
brew cask install skitch
# brew cask install disk-inventory-x
# brew cask install screenflow
brew cask install vlc
# brew cask install gpgtools
# brew cask install licecap
# brew cask install utorrent


# Remove outdated versions from the cellar
# @NOTE: comment out if you want to keep older versions
brew cask cleanup

