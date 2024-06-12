##############################################################################################################
### homebrew, git, and this dotfiles repo

# NOTE: always check https://brew.sh/ first for newer commands
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install homebrew's git
brew install git

# Get env vars before install, specifically HOMEBREW_CASK_OPTS
source ./.exports
# since I don't know how this works yet...
source ./dot_exports

# You may get the error that one of the fonts can't be installed
# You must first install svn:
# brew install svn

# if using homebrew bundle with Brewfile:
# REF: https://docs.brew.sh/Manpage#bundle-subcommand
brew bundle

### end of homebrew
##############################################################################################################




##############################################################################################################
### bash

# change to bash 4 (installed by homebrew)
BASHPATH=$(brew --prefix)/bin/bash
# to add homebrew's bash to the accepted list
sudo bash -c 'echo $(brew --prefix)/bin/bash >> /etc/shells'

### end of bash
##############################################################################################################




##############################################################################################################
### mise

# install most recent version of mise.
curl https://mise.run | sh

# ensure it was installed correctly
echo "mise version:"
~/.local/bin/mise --version
# => xxxx.x.x macos-arm64 (abcdef1 2024-03-21)

# Activate mise
eval "$(~/.local/bin/mise activate zsh)"

# set global defaults to latest
mise use -g node@latest
mise use -g deno@latest
mise use -g python@latest
mise use -g ruby@latest
mise use -g go@latest

### end of mise
##############################################################################################################




##############################################################################################################
### npm

# NOTE:
# The below is just a list of packages to consider installing globally via npm.
# Install using the included `package.json` and `npm install -g`

npm install -g

# Type `git open` to open the GitHub page or website for a repository.
#git-open

# trash as the safe `rm` alternative
#trash-cli

# better Node debugging
#ndb

# simple man pages
#tldr

# for trying out npm modules locally in a REPL
#trymodule

### end of npm
##############################################################################################################




##############################################################################################################
### Base python packages
###

# mise will install common packages via pip after installing the latest python version
# it does so via .default-python-packages

###
##############################################################################################################

