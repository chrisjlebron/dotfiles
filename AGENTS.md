---
Status: Approved
Owner: chrisjlebron
Updated: 2025-11-12
Relates: agents/README.md, docs/chezmoi.md
---

# AGENTS — operating guide for this repo

This file tells human and AI agents how to contribute reliably: where to put things, how to move drafts through review, and what quality gates to follow.

## Scope

- Docs and plans live under `agents/` using the structure below.
- Code changes belong in their normal locations (dotfiles at repo root) and should reference the relevant agent docs.

## What lives where

- Use `agents/` for planning and design documentation (specs, implementation plans, ADRs, todos). The authoritative structure and workflow live in `agents/README.md`.
- Keep code in its natural place at the repo root (dotfiles, scripts, hooks). Reference matching docs from `agents/` where helpful.
- Git hooks live under `hooks/`.

## Workflows

### Documentation workflow (agents/)

- Follow the authoritative playbook in `agents/README.md` for structure, templates, and the promotion workflow. Drafts land in `agents/generated/queue/`, then get triaged and promoted into feature or project namespaces.

### Code change workflow

- Work is scoped to small separate branches.
- **One task at a time**: Wait for user confirmation before proceeding to next task
- **Validate each task**: Before committing your updates, test out the changes to make sure they serve the intended purpose. If you're unable to test out the changes, ask the user to confirm their functionality, providing steps or commands for validation.
- **Generate a commit after each task**: When control is returned to the user, or a user request is deemed "successfully completed", generate an atomic commit with only the relevant touched files
- **Commit message format**: Use conventional commits with descriptive messages and include the `(agent)` scope indicating the commit was generated via an AI agent (e.g. `chore(agent): update dev dependencies`)
- When applicable, lint and test locally.

## File types (repo-wide standards)

### Shell scripts (bash/zsh)

- Shebang: prefer `#!/usr/bin/env bash` unless zsh-specific; keep portable where practical.
- Safety flags: `set -Eeuo pipefail` and a sane `IFS` for bash; use zsh equivalents if zsh-only.
- Lint/format: run shellcheck and shfmt; keep functions small and log clearly on failures.
- Idempotency: provisioning scripts should be safe to re-run.

### Chezmoi conventions

- This repo depends on chezmoi to manage dotfiles updates.
- Authoritative usage instructions live in `docs/chezmoi.md`.
- See also the upstream docs: <https://www.chezmoi.io/>.

### Git hooks (`hooks/`)

- Keep hooks fast and deterministic; avoid network calls.
- Prefer POSIX sh for maximum portability unless there is a strong reason otherwise.

### Documentation (agents/)

- Use the templates in `agents/_templates/` (spec, impl-plan, decision, todo) and include front‑matter.
- For directory layout and promotion rules, see `agents/README.md` and `agents/generated/README.md`.

## Documentation specifics (pointers)

- Feature namespaces: see `agents/README.md` (“Feature namespaces”).
- Promotion workflow: see `agents/README.md` (“Promotion workflow”) and `agents/generated/README.md`.

## Quality gates (must pass)

- Universal: clear intent, small scope, CI/lints green.
- Docs (agents/): front‑matter present and current; markdown hygiene. See `agents/README.md` for details.
- Code: shellcheck/shfmt pass for shell; idempotency for provisioning; include a minimal test or demo when feasible.

## PR guidance

- Prefer small, scoped PRs (one feature slice at a time).
- Use `git mv` when promoting to preserve history.
- In PR description, include: intent, scope, links to affected docs, and checklist of acceptance criteria.

## Naming and conventions

- kebab-case directories; lower-case filenames.
- Use YYYYMMDD-topic.md for dated research notes.
- One topic per document; split when sections get long.

## Safety and secrets

- Do not paste secrets. Reference secret managers (e.g., 1Password) or dynamic exports.
- Avoid network calls in scripts unless explicitly required and documented.

## Quickstart (for new agents)

1. Decide: is this a code change or a doc/update under `agents/`?
2. For docs, read `agents/README.md` and start from a template in `agents/_templates/`.
3. For code, follow the shell/dotfile standards above and run linters locally.
4. Open a small PR linking any related docs; follow the quality gates.

## Contacts

- Owner: @chrisjlebron
- When in doubt: open a draft PR with questions, referencing `AGENTS.md` sections you’re unsure about.
