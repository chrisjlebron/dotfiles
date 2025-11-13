# Agents workspace (authoritative)

This directory is a lightweight workspace for specs, implementation plans, decisions, todos, and short‑lived experiments produced by humans and agents.

## Structure

```text
agents/
  README.md                # This guide
  _templates/              # Reusable doc templates
  project/                 # Cross‑feature docs (roadmap, global ADRs, etc.)
  features/                # Namespaced per feature
  generated/               # Intake area for agent output (promotion queue)
  scripts/maintenance/     # Utilities (cleanup, checks)
```

### File types

- spec.md: Vision, goals, acceptance criteria.
- impl-plan.md: Detailed technical steps and flows.
- decisions.md / decision.md: ADR-style entries.
- todos.md: Backlog slice with small tasks.
- artifacts/: Diagrams, API schemas, code snippets.
- experiments/ and experiments/tmp/: Short‑lived work; tmp is purged regularly.

### Naming and metadata

- kebab-case directories; lower-case files.
- Optional front‑matter on docs:

```yaml
---
Status: Draft | Review | Approved | Deprecated
Owner: <handle>
Updated: YYYY-MM-DD
Relates: <links>
---
```

## Promotion workflow (generated ➝ curated)

1) Ingest: agents drop drafts into `generated/queue/`.
2) Triage: discard noise to `generated/archived/`, or set Status: Review.
3) Prepare: apply template, add metadata/links, split large artifacts.
4) Place: move to `features/<feature>/...` or `project/...` (use `git mv`).
5) Approve: set Status: Approved; cross-link related docs. Deprecate superseded items.

Policy: keep `generated/queue/` off the default branch; prefer PRs that promote content into scoped locations.

## Quality gates and PR checklist

- Structure: Place files per the map above; pick the correct template.
- Metadata: Front‑matter required (Status, Owner, Updated, Relates).
- Lint: Fix markdown basics (blank lines around headings/lists, code fence languages, no trailing spaces).
- Traceability: Add `Relates` links to specs, tickets, or PRs.
- PRs: Prefer small, scoped changes. Use `git mv` when promoting to preserve history. In the PR description include intent, scope, links, and acceptance criteria.
