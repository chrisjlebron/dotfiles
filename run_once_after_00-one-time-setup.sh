#!/bin/bash

###############################################################################
### dotfiles githooks

cat <<- EOF
###############################################################################
### setup dotfiles directory githooks
EOF

# get dotfiles repo path from chezmoi
dotfiles_repo_path=$(chezmoi source-path)

# write git hooksPath
git --git-dir="$dotfiles_repo_path/.git" config core.hooksPath ./hooks

# output hooksPath to var
hooks_path=$(git --git-dir="$dotfiles_repo_path/.git" config core.hooksPath)

# success?
echo "dotfiles repo hooksPath set to $hooks_path at $dotfiles_repo_path"

### end dotfiles githooks
###############################################################################
