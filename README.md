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

## Setup Explained

- Dotfile management is via [chezmoi](https://chezmoi.io/)
- Package management is via [brew](https://brew.sh/)
- Tool version management is via [mise](https://mise.jdx.dev/)
- Shell prompt is managed via [starship](https://starship.rs/)
- Application settings are kinda managed via [mackup](https://github.com/lra/mackup)
- Current preferred terminal emulator is [Warp](https://www.warp.dev/)
- Current preferred Nerd Font is [FiraCode](https://formulae.brew.sh/cask/font-fira-code-nerd-font) (installed via [Brewfile](/literal_Brewfile) "FONTS" section)
- Clipboard history, snippets, and miscellaneous macOS actions managed via [Alfred](https://www.alfredapp.com/)
- Transient, directory-level environment variables managed via [direnv](https://direnv.net/)
- Directory navigation provided by [zoxide](https://github.com/ajeetdsouza/zoxide), in concert with [fzf](https://github.com/junegunn/fzf)
- `cat` made nicer via [bat](https://github.com/sharkdp/bat)
- Git meta (diff, pager, blame, grep) via [delta](https://github.com/dandavison/delta) (see [dot_gitconfig.tmpl](/dot_gitconfig.tmpl) for config)
- Non-Warp zsh plugin management is currently via [zplug](https://github.com/zplug/zplug)

## Gotchas

1. This has currently commented out the zsh package management for Warp
   1. We'll see how far we can get without it
2. Oh-my-zsh git plugin is currently being loaded via a [.chezmoiexternal.toml](/.chezmoiexternal.toml) entry and sourced in [dot_eval](/dot_eval)
   1. Previously these were loaded via zplug
   2. If I decide I need a zsh plugin manager I'll switch back to using that
   3. Includes lots of git aliases you rely on
3. Review output of the `brew install` / `brew bundle` portion for any caveats or actions to take
4. `ls` styling is configured via:
   1. colors are via `LS_COLORS`, which is installed as a [chezmoi external](/.chezmoiexternal.toml) entry and sourced in [dot_eval](/dot_eval)
   2. colors and icons are enabled via `eza` flags (see [dot_aliases](/dot_aliases))
   3. icons are made possible via nerd fonts, which must be selected in your terminal preferences
      - Nerd-fonts are installed via Brewfile
      - Currently favoring fira-code

## Docs

[See docs for more information.](/docs/)

## License

MIT
