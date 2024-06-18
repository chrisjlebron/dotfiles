# dotfiles

Built from chezmoi dotfiles repository template; managed with [chezmoi](https://chezmoi.io/).
Supersedes [old dotfiles](https://github.com/chrisjlebron/dotfiles-old).

## Prerequisites

Perform a backup of your current / old machine

## Getting started

On your new machine, open a terminal and run these commands:

```shell
mkdir -p ~/dev && cd ~/dev
git clone https://github.com/chrisjlebron/dotfiles.git && cd dotfiles
./install.sh
```

## Gotchas

1. This has currently commented out the zsh package management for Warp
   1. We'll see how far we can get without it
2. Oh-my-zsh git plugin is currently being loaded via [.chezmoiexternal.toml](/.chezmoiexternal.toml).
   1. If I decide I need a zsh plugin manager I'll switch to use that

## TODO

- do i need [LS_COLORS](https://github.com/trapd00r/LS_COLORS)?
- do i want inputrc??
- remove zsh package management? replace with another?

## License

MIT
