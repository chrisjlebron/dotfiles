---
Status: Draft
Owner: chrisjlebron
Updated: 2025-11-12
Relates: agents/features/zsh-enhancements/impl-plan.md
---

# Zsh autosuggestions & completions – improvement spec

## Summary

Unify and improve zsh autosuggestions, completion UI, and lightweight plugin management across Warp, Ghostty, kitty (and other terminals) while reducing interactive shell startup time and simplifying configuration layout in the dotfiles repo.

## Goals

- Consistent autosuggestions, syntax highlighting, history substring search, and completion menu select in all terminals.
- Single, cached `compinit` invocation (no duplicates) with 1‑day rebuild policy.
- Replace outdated/autodark autosuggestions fork with canonical repo and readable highlight color.
- Centralize completion styles (`zstyle`) with unified plugin load regardless of terminal detection.
- Reduce cold start latency (target: maintain or improve `time zsh -i -c exit` within ±20ms of current baseline).
- Keep plugin manager footprint minimal (Antidote or equivalent simple sourcing) and list intentionally small.
- Maintain chezmoi layout clarity: dedicated plugin loader file + centralized evaluation logic.

## Non‑Goals

- Implement advanced lazy-loading frameworks (e.g., full Znap optimization) in this iteration.
- Vendoring all plugin sources (may consider later for deterministic builds).
- Rewriting unrelated alias/function files.

## Context and rationale

Current config treats Warp differently and skips plugin manager entirely, producing inconsistent UX. Completion styles and bindings are conditionally applied only in non‑Warp sessions. Autosuggestions use an outdated fork with poor color choice. Startup profiling indicates opportunity to simplify by removing zplug overhead. A unified approach lowers cognitive load and makes future terminal additions trivial.

## Requirements

### Functional

- Load core plugins (autosuggestions, completions, syntax highlighting, history substring search) for all terminals.
- Apply completion styles and keybindings universally after a single `compinit`.
- Provide environment toggles (e.g. `LIGHT_SHELL`, `WARP_USE_ZSH_AUTOSUGGEST`) for opt‑outs without terminal hard‑coding.
- Use canonical repositories for plugins.

### Non‑functional

- Interactive shell startup not regressed beyond ±20ms baseline median.
- Minimal moving parts (one loader file, one evaluation file controlling `compinit`).
- Readable suggestion highlight on dark themes (foreground 245 grey).
- Daily rebuild of `~/.zcompdump` max unless explicitly forced.

## Acceptance criteria

- Warp, Ghostty, kitty sessions show autosuggestions, syntax highlighting, menu selection completion, and working history substring search via arrow keys.
- No duplicate `compinit` calls (verify by instrumenting or profiling).
- Startup benchmark median within ±20ms of prior configuration or improved.
- `~/.zcompdump` rebuild frequency respects 1‑day policy.
- Autosuggestion color changed to `fg=245` and canonical repo used.
- Terminal detection logic no longer disables core plugins by default.

## Risks and mitigations

- Plugin conflict ordering: Load plugins only after `compinit`; keep list minimal → mitigate by explicit sourcing order.
- Security warnings (`compinit` insecure dirs): Maintain default security checks; optionally document `-u` implications rather than enabling blindly.
- Terminal keybinding quirks: Provide fallback bindings using both `$terminfo` and raw sequences.
- Performance regression: Profile with optional `ZSH_STARTUP_PROFILE` env; revert any heavy additions quickly.

## References

- Warp known issues & keybindings: <https://docs.warp.dev/help/known-issues>
- Warp REPL workflow example: <https://docs.warp.dev/university/developer-workflows/backend/how-to-write-sql-commands-inside-a-postgres-repl>
- Canonical autosuggestions: <https://github.com/zsh-users/zsh-autosuggestions>
- Fast syntax highlighting: <https://github.com/zdharma-continuum/fast-syntax-highlighting>
