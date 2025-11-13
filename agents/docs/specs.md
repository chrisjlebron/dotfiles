# Zsh autosuggestions and completions – review and improvement spec

Date: 2025-11-12
Owner: chrisjlebron
Scope: Improve zsh autosuggestions and completions for Warp and other terminals (Ghostty, kitty), reduce shell startup time, and simplify configuration.

## Goals

- Fast, consistent autosuggestions and completions across Warp and non‑Warp terminals.
- Keep `compinit` safe, cached, and centralized (no duplicate inits).
- Modern, actively maintained plugin set; avoid heavy managers or duplicate logic.
- Minimal runtime overhead; measurable startup improvements.
- Keep chezmoi layout sane and easy to reason about.

## Current state (as of this review)

Key files and behavior:

- `dot_zshrc`
  - Skips package manager entirely when `$TERM_PROGRAM == "WarpTerminal"`.
  - For non‑Warp, sources `~/.zsh_package_management` (zplug).
  - Only for non‑Warp: sets completion UI (menu select) and history substring search arrow‑key bindings.
  - Sources `~/.shared` and `~/.completions` later.
- `dot_zsh_package_management`
  - Uses zplug. Installs if missing and loads:
    - `z-shell/F-Sy-H` (fast syntax highlighting)
    - `tarruda/zsh-autosuggestions` (outdated fork; canonical is `zsh-users/zsh-autosuggestions`).
    - `zsh-users/zsh-completions`
    - `zsh-users/zsh-history-substring-search`
    - `lukechilds/zsh-better-npm-completion`
  - Sets `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=0'` (very dark/black → poor visibility on dark themes).
  - Terminal check prevents loading the "non‑Warp" list when Warp is detected, but note this file isn’t sourced at all in Warp due to `dot_zshrc` logic.
- `dot_eval`
  - Centralizes environment and tooling:
    - brew shellenv, starship, mise, direnv, zoxide, git plugin, git‑extras completion.
  - `compinit` is defined here with caching:
    - Adds Homebrew site functions to `FPATH`.
    - If `~/.zcompdump` older than 1 day → `compinit`; else `compinit -C` (skip rebuild).
  - Loads LS_COLORS from `~/.zsh/plugins/ls_colors/lscolors.sh`.
- `dot_completions`
  - Contains custom zsh completion for `thv` (ToolHive) via `compdef _thv thv`.
- `dot_aliases`
  - Aliases for `eza`, git helpers, misc; not directly relevant to completion engine.

Observed characteristics:

- Warp sessions do not load autosuggestions, history substring search, or extra completion definitions from zplug (because `dot_zshrc` skips the package manager entirely).
- Completion styles (`zstyle` menu select and matchers) are only applied for non‑Warp sessions.
- zplug adds cold‑start latency and network footprint; plugin list is reasonable but the autosuggestions source is not the canonical repo.
- `compinit` is already centralized in `dot_eval` (good), but styling lives in `dot_zshrc` under a non‑Warp conditional (inconsistent application).

### Other related files considered (non-blocking)

- `dot_exports.tmpl`
  - Exports locale, editor, pager, starship config selection, misc PATH entries. No direct changes to zsh completion engine or plugin loader. Included here for awareness only.
- `dot_exports-dynamic.tmpl`
  - Chezmoi-rendered dynamic exports (e.g., secrets via 1Password). Not involved in completion initialization or plugin management.
- `dot_functions`
  - User functions/aliases (e.g., `rm()` wrapper, `diff()` wrapper). No `compdef` registrations present; does not affect `compinit` or plugin load order.

## Problems to fix

1. Inconsistent UX between Warp and other terminals (plugins & styles disabled in Warp).
2. Startup latency and maintenance overhead from zplug.
3. Outdated autosuggestions repo; overly dark suggestion color.
4. Completion styles scattered; risk of double init if expanded in future.

## Target experience

- Same core behaviors in Warp, Ghostty, kitty, iTerm: autosuggestions, rich zsh completions, syntax highlighting, and history substring search.
- Completion UI: menu‑select enabled, smart matchers, auto‑rehash after installs, readable formatting.
- Plugin manager that is simple and fast (or static sourcing) with clear, minimal plugin list.
- Tuned autosuggestions: subtle hint color, use history‑first, cap buffer length.

### Warp specifics and interplay

- Warp uses your shell’s native completion system. Improving zsh completion configuration (FPATH, `compinit`, and `zstyle` matchers/menus) benefits Warp directly.
- Warp provides AI-powered assistance (natural language to commands, context-aware prompts) and can inject commands into your shell, but it doesn’t replace inline zsh autosuggestions. Keeping a lightweight `zsh-autosuggestions` improves the typing experience inside Warp.
- Key bindings inside Warp work like a standard terminal; be mindful if binding Tab to `autosuggest-accept` as it may conflict with your existing completion flow.

References:

- Known issues and key bindings: [docs.warp.dev/help/known-issues](https://docs.warp.dev/help/known-issues) (for example, `bindkey 'tab' autosuggest-accept`)
- AI usage across REPLs (illustrates NL→command flow that augments, not replaces, shell completion): [docs.warp.dev/.../postgres-repl](https://docs.warp.dev/university/developer-workflows/backend/how-to-write-sql-commands-inside-a-postgres-repl)

## Options for plugin management

1. Antidote (proposed)

Pros:

- Fast, tiny, straightforward (just a list of repos)
- No background daemon
- Well‑maintained

Cons:

- No lazy‑autoload magic (but list is small)

1. Znap

Pros:

- Aggressive caching/compiling and lazy loading; very fast startup

Cons:

- Adds its own DSL and caching model; slightly more complexity

1. Zcomet/Zinit

Pros:

- Powerful features and defers; popular lineage

Cons:

- More complexity than we need

1. No manager (static sourcing via chezmoi externals)

Pros:

- Zero runtime overhead, deterministic

Cons:

- Requires vendoring plugin files & periodic manual updates

Recommendation: Antidote (keep list small; easy to switch later if needed).

## Proposed plugin set

Core everywhere (Warp and non‑Warp):

- `zsh-users/zsh-completions` – more completions.
- `zsh-users/zsh-autosuggestions` – inline suggestions.
- `zdharma-continuum/fast-syntax-highlighting` – lightweight highlighting.

Non‑Warp extras (optional):

- `zsh-users/zsh-history-substring-search` – consistent keybindings; can also enable in Warp without issues.
- `lukechilds/zsh-better-npm-completion` – opt‑in; minor.

Notes:

- Replace `tarruda/zsh-autosuggestions` with `zsh-users/zsh-autosuggestions`.
- Replace `z-shell/H-S-MW` with `zdharma-continuum/history-search-multi-word` (to maintain alignment with zdharma-continuum managed repos)
- Keep LS_COLORS and git plugin sourcing as‑is via `dot_eval`.

## Completion engine and styles (centralized in `dot_eval`)

- Keep single `compinit` in `dot_eval`.
- Add styles and behavior there so they apply to all terminals:
  - `zstyle ':completion:*' menu select`
  - `zstyle ':completion:*' rehash true`
  - `zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'`
  - `zstyle ':completion:*' completer _complete _match _approximate`
  - `zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'`
  - `zstyle ':completion:*:messages' format '%F{blue}%d%f'`
  - `zstyle ':completion:*:warnings' format '%F{red}%d%f'`
- Keep the 1‑day cache policy (`compinit -C`) and optionally consider `-u` if we trust file modes on macOS (skip security checks).

## Autosuggestions tuning

- `ZSH_AUTOSUGGEST_STRATEGY=(history completion)` – prefer history, fall back to completion.
- `ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40` – avoid scanning long buffers.
- `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245'` – readable on dark themes (instead of `fg=0`).
- Consider adding a toggle env var (e.g., `LIGHT_SHELL=1`) to skip syntax highlighting in constrained shells.

## Keybindings (apply universally)

- Always bind history substring search to arrow keys; Warp doesn’t conflict:
  - `bindkey "$terminfo[kcuu1]" history-substring-search-up`
  - `bindkey "$terminfo[kcud1]" history-substring-search-down`
  - Also include standard mode fallbacks (`cuu1`/`cud1`).

## Terminal detection

- Current check: `$TERM_PROGRAM == "WarpTerminal"`.
- Add awareness (non‑blocking) for others:
  - Ghostty: `$TERM_PROGRAM == "Ghostty"` or `$TERM == "xterm-ghostty"` (varies by version).
  - kitty: `$TERM == "xterm-kitty"`.
- Strategy: Do not disable core plugins on any terminal by default. If terminal provides native features we want to avoid duplicating, introduce explicit opt‑outs via env vars rather than blanket skips.

## File layout changes (minimal)

- Introduce a small plugin loader block (Antidote) in a dedicated file (e.g., `dot_zsh_plugins`) or keep inside `dot_zshrc` but gated below env and after `dot_eval`.
- Remove Warp‑only skip in `dot_zshrc`; instead, choose the same core plugin set for all terminals and optionally extend for non‑Warp.
- Move completion `zstyle` configuration from `dot_zshrc` to `dot_eval` (next to `compinit`).
- Keep `dot_completions` for tool‑specific completions (e.g., ToolHive), loaded after `compinit`.

## Acceptance criteria

- New Warp and non‑Warp interactive shells show inline autosuggestions, syntax highlighting, and completion menu‑select.
- `history-substring-search` works with arrow keys in all terminals.
- `time zsh -i -c exit` improves or stays within ±20ms vs current on macOS Apple Silicon.
- No duplicate `compinit` calls (verify via `functions compinit` count or adding a debug guard during testing).
- `~/.zcompdump` rebuilds at most once per day unless forced.

## Rollout plan

1. Implement Antidote and plugin list; keep zplug temporarily but unused.
2. Move completion styles into `dot_eval`; remove duplicates from `dot_zshrc`.
3. Enable autosuggestion tuning and keybindings for all terminals.
4. Smoke test in Warp, Ghostty, kitty. Benchmark startup.
5. Remove zplug references and (optionally) clean `~/.zplug`.
6. Document changes in `README` and `docs/python-setups.md` (if any CLI impacts), and add short notes to `docs/troubleshooting.md`.

## Risks and mitigations

- Plugin conflicts: Load order – ensure `compinit` happens before tools that register `compdef` (most already do). Keep plugin list small.
- Security warnings on `compinit`: If using `-u`, understand trust implications; otherwise keep default + cache.
- Terminal quirks: Some terminals override keybindings; provide fallback bindings and allow opt‑out via env.

## Optional extras (later)

- Switch to Znap if we want further startup wins; its lazy loading can shave more ms at the cost of complexity.
- Vendoring via chezmoi externals to remove runtime git clones entirely.
- Add a tiny `zprof` profiling toggle: set `ZSH_STARTUP_PROFILE=1` to enable and log hot spots.
  - Planned implementation details:
    - Early in `dot_zshrc`: `if [[ "${ZSH_STARTUP_PROFILE}" == "1" ]]; then zmodload zsh/zprof; fi`
    - End of `dot_zshrc`: `if [[ "${ZSH_STARTUP_PROFILE}" == "1" ]]; then zprof; fi`
    - Default availability via exports: add a conditional default in `dot_exports.tmpl` so the variable exists but can be overridden at call time:

      ```zsh
      # Only set a default if not already defined in the environment
      if [[ -z "${ZSH_STARTUP_PROFILE+x}" ]]; then
        export ZSH_STARTUP_PROFILE=0
      fi
      ```

    - Debugging workflow:
      1. Run a one-off profiled interactive shell: `ZSH_STARTUP_PROFILE=1 zsh -i -c exit`.
      2. Inspect `zprof` output to find heavy initializers (plugins, compinit, sources).
      3. Make a small change and re-run step 1 to compare.
      4. Unset when done to avoid overhead: `unset ZSH_STARTUP_PROFILE`.
