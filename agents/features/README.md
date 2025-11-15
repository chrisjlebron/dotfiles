# Feature namespaces

Create a `feature-slug/` directory for each self-contained feature. Inside each feature, use some or all of:

```text
features/
  <feature-slug>/
    spec.md
    impl-plan.md
    decisions.md
    todos.md
    artifacts/
      diagrams/
      api/
      snippets/
    experiments/
      tmp/
```

Notes:

- Keep `spec.md` and `impl-plan.md` focused on this feature only.
- Put disposables in `experiments/tmp/` and clean up after promotion.
- Use templates from `agents/_templates/` to start new docs.

