#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'

# Run after every apply because tool upgrades happen independently of chezmoi
# source changes. Generated files are replaced only when their contents change.
completion_dir="${ZSH_COMPLETION_DIR:-${HOME}/.zsh/completions}"
mkdir -p "$completion_dir"

work_dir="$(mktemp -d "${TMPDIR:-/tmp}/zsh-completions.XXXXXX")"
target_tmp=""
cleanup() {
  if [[ -n "$target_tmp" ]]; then
    rm -f -- "$target_tmp"
  fi
  rm -rf -- "$work_dir"
}
trap cleanup EXIT

updated_count=0
unchanged_count=0
missing_count=0
failed_count=0

generate_completion() {
  local output_name="$1"
  local binary_name="$2"
  shift 2

  local binary_path generated_file target_file
  if ! binary_path="$(command -v "$binary_name" 2>/dev/null)"; then
    printf 'Skipping %s completion: %s is not installed or not on PATH.\n' \
      "$output_name" "$binary_name" >&2
    missing_count=$((missing_count + 1))
    return 0
  fi

  generated_file="${work_dir}/${output_name}"
  target_file="${completion_dir}/${output_name}"

  # Bun and opencode inspect SHELL when choosing their completion dialect.
  if ! SHELL=zsh "$binary_path" "$@" </dev/null >"$generated_file"; then
    printf 'Skipping %s completion: generator failed; keeping any cached file.\n' \
      "$output_name" >&2
    failed_count=$((failed_count + 1))
    return 0
  fi

  if [[ ! -s "$generated_file" ]]; then
    printf 'Skipping %s completion: generator returned no output; keeping any cached file.\n' \
      "$output_name" >&2
    failed_count=$((failed_count + 1))
    return 0
  fi

  if [[ "$(LC_ALL=C awk 'NR == 1 { print; exit }' "$generated_file")" != '#compdef '* ]]; then
    printf 'Skipping %s completion: output has no leading #compdef; keeping any cached file.\n' \
      "$output_name" >&2
    failed_count=$((failed_count + 1))
    return 0
  fi

  if [[ -f "$target_file" ]] && cmp -s "$generated_file" "$target_file"; then
    unchanged_count=$((unchanged_count + 1))
    return 0
  fi

  target_tmp="$(mktemp "${completion_dir}/.${output_name}.XXXXXX")"
  cp "$generated_file" "$target_tmp"
  chmod 0644 "$target_tmp"
  mv -f "$target_tmp" "$target_file"
  target_tmp=""
  updated_count=$((updated_count + 1))
}

pnpm_binary="pnpm"
if mise_binary="$(command -v mise 2>/dev/null)" &&
  mise_pnpm_binary="$("$mise_binary" which pnpm 2>/dev/null)" &&
  [[ -x "$mise_pnpm_binary" ]]; then
  # The dedicated mise install also registers pn; Corepack's shim does not.
  pnpm_binary="$mise_pnpm_binary"
fi

generate_completion _mise mise completion zsh
generate_completion _pnpm "$pnpm_binary" completion zsh
generate_completion _deno deno completions zsh
generate_completion _rustup rustup completions zsh rustup
generate_completion _cargo rustup completions zsh cargo
generate_completion _uv uv generate-shell-completion zsh
generate_completion _uvx uvx --generate-shell-completion zsh
generate_completion _bun bun completions
generate_completion _codex codex completion zsh
generate_completion _ruff ruff generate-shell-completion zsh
generate_completion _docker docker completion zsh
generate_completion _opencode opencode --completions zsh

printf 'Zsh completion cache: %d updated, %d unchanged, %d missing, %d failed.\n' \
  "$updated_count" "$unchanged_count" "$missing_count" "$failed_count"
