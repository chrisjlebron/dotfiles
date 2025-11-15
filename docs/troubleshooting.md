# Troubleshooting

## Shell startup profiling

- Set `ZSH_STARTUP_PROFILE=1` before starting a new shell (`ZSH_STARTUP_PROFILE=1 zsh -i -c exit`) to enable `zprof` instrumentation.
- When the toggle is on, `dot_zshrc` loads `zsh/zprof` early and prints the profile report on exit. Disable by unsetting the variable or exporting `ZSH_STARTUP_PROFILE=0`.
- `zprof` output is noisy; redirect to a file if you need to analyze repeatedly, for example `ZSH_STARTUP_PROFILE=1 zsh -i -c exit &> ~/Desktop/zprof.log`.

## Completion cache and plugin loader

- `dot_eval` owns `compinit` with a one-day cache policy. Force a rebuild with `rm ~/.zcompdump*` followed by launching a new shell.
- Antidote plugin bundles are generated from `dot_zsh_plugins.txt.base` plus runtime toggles in [`dot_zsh_plugins_management.tmpl`](../dot_zsh_plugins_management.tmpl). Re-run `chezmoi apply` after editing the base list to rewrite `~/.zsh_plugins.txt`.
- `LIGHT_SHELL=1` trims the plugin set (skips syntax highlighting) without editing dotfiles.

## Benchmarking changes quickly

- Use `time zsh -i -c exit` to capture cold-start timing. Run it a few times and compare medians before and after changes.
- For load-order inspection, `zsh -l --sourcetrace` prints each sourced file—handy when diagnosing unexpected overrides.
- You may also want to use [`zsh-bench`](https://github.com/romkatv/zsh-bench)

## Zsh load order refresher

1. `.zshenv`
2. `.zprofile` (login shells)
3. `.zshrc` (interactive shells)
4. `.zlogin` (login shells)
5. `.zlogout`

`.zshrc` is the intended spot for interactive niceties; avoid putting prompt logic in `.zshenv` to keep non-interactive shells lean.


