# chezmoi

<https://www.chezmoi.io/>

## chezmoiignore

List any files or directories that you don't want chezmoi to run or copy to $HOME
See [.chezmoiignore](/.chezmoiignore)

## Useful commands

See all chezmoi commands: <https://www.chezmoi.io/reference/commands/verify/>

⚠️ Note: I have the alias `cm` set up to simplify (see [/dot_aliases](/dot_aliases))

```shell
# alias for `chezmoi`
cm

# print out all chezmoi data, including inputs from templates
chezmoi data

# see what has changed and how it will change (https://www.chezmoi.io/reference/commands/status/)
chezmoi status

# see a diff of source & $HOME
chezmoi diff

# edit chezmoi config (this governs the template values, e.g. .gitconfig GH PAT)
chezmoi edit-config

# general warnings & advice
chezmoi doctor

# see which files in $HOME are not tracked by chezmoi
chezmoi unmanaged

# add file from $HOME to source dir
chezmoi add ~/FILE

# apply any changes in source to home dir
chezmoi apply
```

## Agents Meta

### Chezmoi Conventions

Key patterns adopted in this repo:

- File naming & mapping
  - See <https://www.chezmoi.io/reference/source-state-attributes/> for naming conventions (e.g. `dot_<name>` becomes `.<name>` in `$HOME`, (e.g. `dot_zshrc` → `~/.zshrc`); template dotfiles end with `.tmpl` suffix, which is removed after rendering (e.g. `dot_gitconfig.tmpl` → `~/.gitconfig`)).
  - Dynamic template example: `dot_exports-dynamic.tmpl` produces exports that depend on template data; keep logic minimal and portable.
- Script entry points & ordering
  - Use chezmoi run script naming conventions
  - See <https://www.chezmoi.io/reference/target-types/> and <https://www.chezmoi.io/reference/application-order/> for more information on script targets, entry points, & ordering
  - Numeric prefixes (`00-`, `01-`, ..., `99-`) define deterministic order.
    - `run_once_after_00-one-time-setup.sh`: bootstrap steps executed exactly once.
    - `run_onchange_after_00-install-core-utils.sh`: idempotent install that re-runs if script or template changes.
    - `run_onchange_after_01-apply-dynamic-exports.sh`: applies regenerated exports after data changes.
    - `run_onchange_after_99-macos.sh`: late macOS tweaks; high number defers until other changes settle.
  - New scripts MUST be idempotent, portable (`#!/usr/bin/env bash` + `set -Eeuo pipefail`), fast (avoid long network operations unless documented), and use an ordering number that does not conflict.
- Updating config & template data
  - Inspect current data: `chezmoi data`.
  - Edit template/user config: `chezmoi edit-config` (never commit secrets—reference external secret managers or dynamic exports).
  - Preview changes before applying: `chezmoi diff`, `chezmoi status`; then if changes are valid / verified, `chezmoi apply`.
- Prefer templates (`.tmpl`) when values differ by host/user context; keep logic simple and validate with `chezmoi data`.
- Secrets & sensitive values
  - Never store secrets directly in templates; use environment variable indirection or dedicated secret tooling referenced via dynamic exports.
- Cross‑referencing agent docs
  - When a change to chezmoi behavior implements a feature, create or update a spec/impl plan under `agents/features/<feature>/` and link back here & `docs/chezmoi.md`.

### Checklist for chezmoi‑related PRs

1. Correct naming applied.
2. Scripts are idempotent and ordered numerically without collision.
3. No secrets committed; dynamic exports/template logic minimal.
4. Preview (`chezmoi diff`) reviewed before apply.
