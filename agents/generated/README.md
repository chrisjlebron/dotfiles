# Generated content intake

Use this area to collect raw agent output before curation.

## States

- queue/: new, unreviewed drafts
- accepted/: promoted items (optional staging before final placement)
- archived/: discarded or superseded items

## Promotion steps

1. Triage items in `queue/` (discard noise, mark promising ones)
2. Apply a template and add metadata (Owner, Status, Updated, Relates)
3. Move to `features/<feature>/...` or `project/...` with `git mv`
4. Mark Status: Approved on merge and link related docs

Policy: avoid committing `generated/queue/` to the default branch; prefer PRs that promote content out of the queue.

