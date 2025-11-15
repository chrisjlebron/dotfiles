# Benchmarks

## Tools used

- `zsh-bench` -> `~/zsh-bench/zsh-bench`
- `time` -> `for i in $(seq 10); do /usr/bin/time zsh -lic exit; done`

## Before

### Warp

```shell
# zsh-bench

creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=0
has_git_prompt=1
first_prompt_lag_ms=173.686
first_command_lag_ms=173.958
command_lag_ms=50.431
input_lag_ms=0.153
exit_time_ms=125.407
```

```shell
# for i in $(seq 10); do /usr/bin/time zsh -lic exit; done

        0.14 real         0.06 user         0.05 sys
        0.12 real         0.06 user         0.04 sys
        0.12 real         0.06 user         0.04 sys
        0.12 real         0.06 user         0.04 sys
        0.12 real         0.06 user         0.05 sys
        0.12 real         0.06 user         0.04 sys
        0.12 real         0.06 user         0.04 sys
        0.12 real         0.06 user         0.04 sys
        0.12 real         0.06 user         0.04 sys
        0.12 real         0.06 user         0.04 sys
```

### Ghostty

- zsh-bench wouldn't complete...

```shell
# for i in $(seq 10); do /usr/bin/time zsh -lic exit; done

        0.61 real         0.30 user         0.27 sys
        0.29 real         0.15 user         0.11 sys
        0.29 real         0.15 user         0.11 sys
        0.29 real         0.15 user         0.11 sys
        0.29 real         0.15 user         0.11 sys
        0.29 real         0.15 user         0.11 sys
        0.29 real         0.15 user         0.11 sys
        0.29 real         0.15 user         0.11 sys
        0.33 real         0.16 user         0.13 sys
        0.29 real         0.15 user         0.11 sys
```

### Terminal

- zsh-bench wouldn't complete

```shell
# for i in $(seq 10); do /usr/bin/time zsh -lic exit; done

        0.62 real         0.30 user         0.27 sys
        0.30 real         0.15 user         0.12 sys
        0.30 real         0.15 user         0.12 sys
        0.30 real         0.15 user         0.12 sys
        0.30 real         0.15 user         0.12 sys
        0.30 real         0.15 user         0.12 sys
        0.30 real         0.15 user         0.12 sys
        0.31 real         0.15 user         0.12 sys
        0.32 real         0.16 user         0.13 sys
        0.32 real         0.15 user         0.13 sys
```

## After

### Warp

```shell
# zsh-bench

creates_tty=0
has_compsys=1
has_syntax_highlighting=1
has_autosuggestions=0
has_git_prompt=1
first_prompt_lag_ms=185.154
first_command_lag_ms=187.105
command_lag_ms=43.994
input_lag_ms=3.468
exit_time_ms=138.370
```

```shell
# for i in $(seq 10); do /usr/bin/time zsh -lic exit; done

        0.14 real         0.07 user         0.05 sys
        0.13 real         0.06 user         0.05 sys
        0.13 real         0.06 user         0.05 sys
        0.13 real         0.06 user         0.05 sys
        0.13 real         0.06 user         0.05 sys
        0.13 real         0.06 user         0.05 sys
        0.13 real         0.06 user         0.05 sys
        0.13 real         0.06 user         0.05 sys
        0.13 real         0.06 user         0.05 sys
        0.13 real         0.06 user         0.05 sys
```

### Ghostty

```shell
# zsh-bench

creates_tty=0
has_compsys=1
has_syntax_highlighting=1
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=203.663
first_command_lag_ms=206.936
command_lag_ms=60.303
input_lag_ms=4.176
exit_time_ms=144.859
```

```shell
# for i in $(seq 10); do /usr/bin/time zsh -lic exit; done

        0.22 real         0.07 user         0.08 sys
        0.14 real         0.06 user         0.05 sys
        0.14 real         0.06 user         0.05 sys
        0.14 real         0.06 user         0.05 sys
        0.14 real         0.06 user         0.05 sys
        0.14 real         0.06 user         0.05 sys
        0.14 real         0.06 user         0.05 sys
        0.14 real         0.06 user         0.05 sys
        0.14 real         0.06 user         0.05 sys
        0.14 real         0.06 user         0.05 sys
```

### Terminal

```shell
# zsh-bench

creates_tty=0
has_compsys=1
has_syntax_highlighting=1
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=208.213
first_command_lag_ms=211.437
command_lag_ms=61.151
input_lag_ms=4.143
exit_time_ms=154.538
```

```shell
# for i in $(seq 10); do /usr/bin/time zsh -lic exit; done

        0.23 real         0.08 user         0.08 sys
        0.15 real         0.07 user         0.05 sys
        0.15 real         0.07 user         0.06 sys
        0.15 real         0.07 user         0.05 sys
        0.15 real         0.07 user         0.05 sys
        0.15 real         0.07 user         0.05 sys
        0.15 real         0.07 user         0.05 sys
        0.15 real         0.07 user         0.05 sys
        0.15 real         0.07 user         0.05 sys
        0.15 real         0.07 user         0.05 sys
```

## Conclusion

- Warp startup remains within the ±20 ms target window (≈0.12–0.14 s → ≈0.13–0.14 s real)
- Ghostty and Terminal improve significantly (≈0.29–0.30 s → ≈0.14–0.15 s real)
- With completions, syntax highlighting, and autosuggestions enabled post-change, the performance acceptance criteria are met or exceeded across all measured terminals.
