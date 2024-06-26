# dotfiles

Built from chezmoi dotfiles repository template; managed with [chezmoi](https://chezmoi.io/).
Supersedes [old dotfiles](https://github.com/chrisjlebron/dotfiles-old).

## Prerequisites

Perform a backup of your current / old machine

TODO: fill in…

## Getting started

On your new machine, open a terminal and run these commands:

```shell
mkdir -p ~/dev && cd ~/dev
git clone https://github.com/chrisjlebron/dotfiles.git && cd dotfiles
# time the whole process, for interest
time ./install.sh
```

If you want to add a GitHub personal access token now:

- Login to GitHub with Safari & 1password
- Generate new token
  - See [GitHub Docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- Paste into setup when prompted
- chezmoi writes it to a local file that is unique per device and doesn't get synced to the cloud

Otherwise, you can add it later using `chezmoi edit-config` or the command chezmoi displays on initial bootstrap steps.

## Gotchas

1. This has currently commented out the zsh package management for Warp
   1. We'll see how far we can get without it
2. Oh-my-zsh git plugin is currently being loaded via [.chezmoiexternal.toml](/.chezmoiexternal.toml).
   1. If I decide I need a zsh plugin manager I'll switch to use that
3. Review output of the `brew install` / `brew bundle` portion for any caveats or actions to take
4. `ls` styling is configured via:
   1. colors are via `LS_COLORS`, which is installed as a chezmoi external and sourced in [dot_eval](/dot_eval)
   2. colors and icons are enabled via `eza` flags (see [dot_aliases](/dot_aliases))
   3. icons are made possible via nerd fonts, which must be selected in your terminal preferences
      - Nerd-fonts are installed via Brewfile
      - Currently favoring fira-code

## Docs

[See docs for more information.](/docs/)

## TODO

- do i need [LS_COLORS](https://github.com/trapd00r/LS_COLORS)?
- do i want inputrc??
- remove zsh package management? replace with another?

## License

MIT
