#!/bin/bash

# Install command-line tools using Homebrew

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade


# GNU core utilities (those that come with OS X are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
brew install moreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
# GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed --default-names


# Bash 4
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before running `chsh`.
brew install bash
brew tap homebrew/versions
brew install bash-completion2

brew install homebrew/completions/brew-cask-completion

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew install grc

# Install wget with IRI support
brew install wget --with-iri

# Install more recent versions of some OS X tools
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen


# run this script when this file changes guy.
brew install entr

# github util. imho better than hub
# brew install gh

# gh was merged with hub...
brew install hub

# for nice git commands, like standup summaries and smart code review handling
brew install git-extras

# personal
brew install ctags
# brew install gdbm
# brew install openssl
# brew install pkg-config
brew install python
# brew install readline
brew install redis
# brew install sqlite
brew install mongodb
brew install hh # smart history search
brew install htop # better top


# mtr - ping & traceroute. best.
brew install mtr

    # allow mtr to run without sudo
    mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//') #  e.g. `/Users/paulirish/.homebrew/Cellar/mtr/0.86`
    sudo chmod 4755 $mtrlocation/sbin/mtr
    sudo chown root $mtrlocation/sbin/mtr


# Install other useful binaries
brew install ack
brew install the_silver_searcher
brew install fzf

brew install git
brew install git-flow
brew install imagemagick --with-webp
brew install node # This installs `npm` too using the recommended installation method
brew install pv
brew install rename
brew install tree
brew install zopfli
brew install ffmpeg --with-libvpx
brew install mitmproxy # alternative to Charles Proxy

brew install terminal-notifier

brew install android-platform-tools
brew install pidcat   # colored logcat guy

brew install zsh

# Better git diffs in cli (already referenecd in .gitconfig)
#  brew install diff-so-fancy
brew install icdiff

# Remove outdated versions from the cellar
brew cleanup
