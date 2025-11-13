---
Status: Draft
Owner: chrisjlebron
Updated: 2025-11-12
Relates: agents/features/zsh-enhancements/spec.md
---

# Implementation plan – zsh enhancements

## Overview

Deliver a unified, performant shell experience across terminals by standardizing plugin loading (Antidote), centralizing completion configuration, applying autosuggestion tuning, and removing zplug overhead.

## Architecture and flow

- `dot_zshrc` sources env (`dot_eval`), then plugin loader (`dot_zsh_plugins`), then aliases/functions.
- `dot_eval` performs single `compinit` + completion `zstyle` setup (cache: daily rebuild logic).
- `dot_zsh_plugins` installs/loads Antidote (if absent) and sources a plugin bundle list.
- Optional profiling (`ZSH_STARTUP_PROFILE=1`) activates `zprof` around initialization.

## Steps

1. Add `dot_zsh_plugins` file with Antidote bootstrap and plugin list.
2. Source `dot_zsh_plugins` unconditionally in `dot_zshrc` (remove Warp skip logic).
3. Move all completion `zstyle` lines from `dot_zshrc` to `dot_eval` below `compinit`.
4. Apply autosuggestion variables (strategy, buffer size, highlight) in plugin loader.
5. Add history substring search keybindings using `$terminfo` codes and fallbacks.
6. Introduce env toggles (`LIGHT_SHELL`, `WARP_USE_ZSH_AUTOSUGGEST`).
7. Add profiling hooks (`zmodload zsh/zprof` early; `zprof` output late when enabled).
8. Benchmark pre/post (≥3 runs) and record medians.
9. Remove zplug sourcing + optionally clean `~/.zplug` after verification.
10. Update docs (`README`, troubleshooting) with new layout and toggles.

## Data shapes and contracts

- Env toggles: boolean-like (0/1) presence; absence defaults to enabling features.
- Plugin list: ordered array of repo slugs passed to Antidote loader.

## Edge cases and failure modes

- Missing network during first Antidote install → fallback message; user can retry; shell still usable.
- Insecure directory warning from `compinit` → document remediation (fix permissions or opt‑in `-u`).
- Terminal without `$TERM_PROGRAM` (e.g., minimal SSH) → features remain enabled; performance impact minimal.

## Observability

- Manual benchmarking with `time zsh -i -c exit`.
- Optional `zprof` output when `ZSH_STARTUP_PROFILE=1`.

## Rollback/exit strategy

Retain previous zplug file until confident; rollback by re‑adding its source line. Keep old plugin list commented for reference during transition.

## Plugin options considered

| Option | Pros | Cons | Decision |
| ------ | ---- | ---- | -------- |
| Antidote | Fast, simple | No lazy loading | Chosen |
| Znap | Very fast | Added complexity | Defer |
| Vendored static | Zero runtime overhead | Manual updates | Later |

## Proposed plugin set

Core (all terminals):

- `zsh-users/zsh-completions`
- `zsh-users/zsh-autosuggestions`
- `zdharma-continuum/fast-syntax-highlighting`
- `zsh-users/zsh-history-substring-search`

Optional / future: `lukechilds/zsh-better-npm-completion` (low impact).

## Completion styles (to apply in `dot_eval`)

```zsh
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*:messages' format '%F{blue}%d%f'
zstyle ':completion:*:warnings' format '%F{red}%d%f'
```

## Autosuggestions tuning

```zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245'
```

## Keybindings

```zsh
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey "${terminfo[cuu1]}" history-substring-search-up
bindkey "${terminfo[cud1]}" history-substring-search-down
```

## Terminal detection (informational)

Do not disable features based on `$TERM_PROGRAM`; rely on opt‑out env vars.

## Rollout checklist (for todos.md)

- Add loader file
- Source loader from zshrc
- Move completion styles
- Apply tunables
- Add keybindings
- Add profiling hooks
- Benchmark
- Remove zplug
- Update docs
