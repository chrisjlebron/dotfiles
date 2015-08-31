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
# brew cask install onepassword
brew cask install rescuetime
brew cask install flux
brew cask install spotify
brew cask install slack

# dev
brew cask install atom
brew cask install iterm2
# brew cask install sublime-text
brew cask install imagealpha
brew cask install imageoptim
brew cask install p4merge
brew cask install rowanj-gitx
brew cask install vagrant
brew cask install virtualbox

# fun
# brew cask install limechat
# brew cask install miro-video-converter
# brew cask install horndis               # usb tethering

# browsers
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefox
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
# brew cask install screenflow4 # 4 specifically not 5.
brew cask install vlc
# brew cask install gpgtools
# brew cask install licecap
# brew cask install utorrent


# Not on cask but I want regardless.

# 3Hub   https://itunes.apple.com/us/app/3hub/id427515976?mt=12
# File Multi Tool 5
# Phosphor
