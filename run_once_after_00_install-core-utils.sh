#!/bin/bash

###############################################################################
### install macOS CLI tools

# Pre-requisite for homebrew
cat <<- EOF
###############################################################################
### install macOS CLI tools
EOF

xcode-select --install

### end install macOS CLI tools
###############################################################################




###############################################################################
### install homebrew

cat <<- EOF
###############################################################################
### install homebrew
EOF

# NOTE: always check https://brew.sh/ first for newer commands
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

### end of homebrew
###############################################################################




###############################################################################
### mise

cat <<- EOF
###############################################################################
### install mise & packages
EOF

# Check if mise is already installed, install if not
if ! command -v ~/.local/bin/mise >/dev/null; then
  # install most recent version of mise.
  curl https://mise.run | sh

  # Activate mise
  eval "$(~/.local/bin/mise activate zsh)"
fi

# ensure it was installed correctly
if ! version="$(mise --version)"; then
  echo "mise not installed or activated correctly. exiting..."
  exit 1
fi

echo "mise version:"
echo "$version"
# => xxxx.x.x macos-arm64 (abcdef1 2024-03-21)

# set global defaults to latest
mise use -g node@latest
mise use -g deno@latest
mise use -g python@latest
mise use -g ruby@latest
mise use -g go@latest

# just in case... (mise's node is needed for npm, maybe brew?)
if [[ $(which node) != *mise* ]]; then
  echo "activating mise..."
  eval "$(~/.local/bin/mise activate zsh)"
fi

### end of mise
###############################################################################



###############################################################################
### install homebrew packages

cat <<- EOF
###############################################################################
### install homebrew packages
EOF

# Get env vars before install, specifically HOMEBREW_CASK_OPTS
source ~/.exports

# You may get the error that one of the fonts can't be installed
# If yes, you must first install svn:
# brew install svn

# Using homebrew bundle with Brewfile:
# REF: https://docs.brew.sh/Manpage#bundle-subcommand
brew bundle

### end install homebrew packages
###############################################################################




###############################################################################
### npm

cat <<- EOF
###############################################################################
### installing global npm packages
EOF

# NOTE:
# The below is just a list of packages to consider installing globally via npm.
# Install using the included `package.json` and `npm install -g`

npm install -g

# git-open: Type `git open` to open the GitHub page or website for a repository.
# trash-cli: trash as the safe `rm` alternative
# ndb: better Node debugging
# tldr: simpler man pages
# trymodule: for testing out npm modules locally in a REPL

### end of npm
###############################################################################




###############################################################################
### bash

cat <<- EOF
###############################################################################
### setting bash to brew bash
EOF

# change to bash 4 (installed by homebrew)
BASHPATH=$(brew --prefix)/bin/bash

# to add homebrew's bash to the accepted list
sudo bash -c 'echo $BASHPATH >> /etc/shells'

### end of bash
###############################################################################




###############################################################################
### Base python packages

# mise will install common packages via pip after installing the latest python version
# It does so via .default-python-packages

### end Base python packages
###############################################################################
