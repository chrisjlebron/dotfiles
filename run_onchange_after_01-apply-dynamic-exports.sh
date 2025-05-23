#!/bin/bash

###############################################################################
### Kick off script

# We're doing this to ensure template values are available on first run

cat <<- EOF
###############################################################################
### Re-apply chezmoi dynamic templates
EOF

read -p "Do you want to run chezmoi apply for dynamic templates? (y/N) " answer

if [[ "$answer" == [yY] ]]; then
  echo "Beginning dynamic template steps..."
else
  echo "Moving on..."
  exit 0
fi

###############################################################################
### ensure 1password CLI access

if command -v op >/dev/null; then
  # Check if we're signed in
  if ! op account get >/dev/null 2>&1; then
    echo "Please sign in to 1password first"
    op signin
  fi

  echo "1password CLI detected and signed in, updating credentials..."

  # grab file path
  exports_dynamic_src_file=$(chezmoi source-path ~/.exports-dynamic)

  # using `execute-template` rather than `apply` because chezmoi locks the state in the outer call
  # (either `init` or `apply`, depending when this is run)
  # this is the recommended method (REF: https://www.chezmoi.io/reference/commands/execute-template/)
  chezmoi execute-template < "$exports_dynamic_src_file" > ~/.exports-dynamic

  # finally, make the exports available in the current terminal session
  source ~/.exports-dynamic
else
  echo "1password CLI not found, skipping credential updates"
fi
