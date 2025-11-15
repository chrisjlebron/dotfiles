---
Status: Draft
Owner: chrisjlebron
Updated: 2025-11-13
Relates: agents/features/zsh-enhancements/impl-plan.md
---

# TODOs – zsh enhancements

## Legend

- [ ] open
- [x] done
- [~] in-progress

## Tasks

| ID | Task | Status | Priority | Owner | Notes |
| --- | ---- | ------ | -------- | ----- | ----- |
| ZSH-001 | Create `dot_zsh_plugins` with Antidote bootstrap | [x] | H | chrisjlebron | New loader file |
| ZSH-002 | Source loader unconditionally in `dot_zshrc` | [x] | H | chrisjlebron | Remove Warp skip |
| ZSH-003 | Move completion zstyle config to `dot_eval` | [x] | H | chrisjlebron | After compinit |
| ZSH-004 | Add autosuggestion tunables | [x] | M | chrisjlebron | strategy, buffer, style |
| ZSH-005 | Add history substring search keybindings | [x] | M | chrisjlebron | arrow + fallbacks |
| ZSH-006 | Add env toggles (LIGHT_SHELL, WARP_USE_ZSH_AUTOSUGGEST) | [x] | M | chrisjlebron | opt-outs |
| ZSH-007 | Add profiling hooks (`ZSH_STARTUP_PROFILE`) | [x] | L | chrisjlebron | optional performance |
| ZSH-008 | Benchmark before changes | [x] | H | chrisjlebron | capture baseline |
| ZSH-009 | Benchmark after changes | [x] | H | chrisjlebron | compare median |
| ZSH-010 | Remove zplug references & clean directory | [ ] | M | chrisjlebron | post-validation |
| ZSH-011 | Update documentation (README, troubleshooting) | [ ] | M | chrisjlebron | reflect new layout |
| ZSH-012 | Verify no duplicate compinit calls | [ ] | H | chrisjlebron | instrumentation or echo guard |
| ZSH-013 | Add default `ZSH_STARTUP_PROFILE` export in `dot_exports.tmpl` (conditional) | [x] | M | chrisjlebron | `if [[ -z "${ZSH_STARTUP_PROFILE+x}" ]]; then export ZSH_STARTUP_PROFILE=0; fi` |
| ZSH-014 | Document Warp autosuggestion opt-out toggle | [ ] | M | chrisjlebron | `WARP_USE_ZSH_AUTOSUGGEST=0` in docs |
