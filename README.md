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
- Generate new token:
  - See [GitHub Docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
  - PAT should have at least the following permissions
    - `repo`
    - `workflow`
    - `read:org`
- Paste into setup when prompted
- chezmoi writes it to a local file that is unique per device and doesn't get synced to the cloud
- To use `gh` as a credential helper (this helps with VS Code Devcontainers; see <https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git>), run:

  ```shell
  gh auth login
  ```

  - Set it to use:
    - GitHub.com
    - HTTPS as preferred protocol
    - Authenticate wit GitHub credentials
    - Paste in authentication token
  - And then paste in the PAT generated in an earlier step here
  - It should inform you that you're logged in as `username` (your GitHub username / handle)
  - You can also manually confirm with:

  ```shell
  gh auth status
  ```

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
- zsh plugin management is currently via [antidote](https://antidote.sh/)

## Gotchas

1. This uses a reduced set of zsh plugins for Warp
2. Oh-my-zsh git plugin is currently being loaded via a [.chezmoiexternal.toml](/.chezmoiexternal.toml) entry and sourced in [dot_eval](/dot_eval)
   - Includes lots of git aliases you rely on, so don't scrap it!
3. Review output of the `brew install` / `brew bundle` portion for any caveats or actions to take
4. `ls` styling is configured via:
   1. colors are via `LS_COLORS`, which is installed as a [chezmoi external](/.chezmoiexternal.toml) entry and sourced in [dot_eval](/dot_eval)
   2. colors and icons are enabled via `eza` flags (see [dot_aliases](/dot_aliases))
   3. icons are made possible via nerd fonts, which must be selected in your terminal preferences
     - Nerd-fonts are installed via Brewfile
     - Currently favoring fira-code
5. Chezmoi staging vs live dotfiles
   1. This repository is the "source state". Changes here are not active until applied to `$HOME` via `chezmoi apply` (or during `./install.sh`).
   2. This affects how you would benchmark shell startup performance:
      - Collect Baseline: run `time zsh -i -c exit` ≥3 times before applying new changes (reflects currently applied dotfiles in `$HOME`).
      - Apply changes: `chezmoi apply` (or `chezmoi apply --include dotfiles,scripts` for a narrower scope).
      - Post-change: re-run `time zsh -i -c exit` ≥3 times; compare medians to baseline.
     - Profiling: set `ZSH_STARTUP_PROFILE=1` in the applied environment (export is added in `dot_exports.tmpl`); then start a shell to view `zprof` output.

## Docs

[See docs for more information.](/docs/)

### Environment Variables and toggles

- Profiling toggle: set `ZSH_STARTUP_PROFILE=1` before launching a shell to enable `zprof` output.
- Opt-out envs (Set these in your environment or via a local override rather than editing applied files for quick experiments):
  - `LIGHT_SHELL=1` to skip syntax highlighting.
  - `WARP_USE_ZSH_AUTOSUGGEST=0` to disable autosuggestions in Warp.

## License

MIT
