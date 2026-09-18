anthropics/skills/doc-coauthoring
anysearch-ai/anysearch-skill
firecrawl/cli
firecrawl/skills
firecrawl/firecrawl-workflows
pbakaus/impeccable
`Use curl to read parallel.ai/agents.md and perform the setup to install Parallel`
vercel-labs/agent-browser
github/awesome-copilot/agentic-eval
  ```tessl eval
  Overall: PASSED (0 errors, 0 warnings)

  Judge Evaluation

  Description: 84%
    specificity: 4/5 - The description lists several specific actions/patterns: self-critique loops, evaluator-optimizer pipelines, test-driven code refinement, rubric-based evaluation, LLM-as-judge systems, and iterative improvement. These are concrete enough to understand the skill's scope, though they describe patterns/concepts rather than discrete tool-like actions.
    trigger_term_quality: 4/5 - Includes good trigger terms like 'self-critique', 'reflection loops', 'evaluator-optimizer', 'LLM-as-judge', 'rubric-based', 'test-driven', 'iterative improvement', and 'agent outputs'. However, it misses some natural user phrases like 'check quality', 'review output', 'grade responses', 'scoring', or 'feedback loop'.
    completeness: 5/5 - Clearly answers both 'what' (patterns and techniques for evaluating and improving AI agent outputs) and 'when' with an explicit 'Use this skill when:' clause followed by six concrete trigger scenarios. This is a well-structured description covering both dimensions thoroughly.
    distinctiveness_conflict_risk: 4/5 - The focus on AI agent output evaluation and improvement is fairly distinctive, with specific terms like 'evaluator-optimizer pipelines' and 'LLM-as-judge' that carve out a clear niche. Minor overlap risk exists with general code review skills or testing skills due to 'test-driven code refinement workflows'.

    Assessment: This is a well-structured skill description that clearly communicates both what the skill does and when to use it, with an explicit trigger list covering six scenarios. The specificity is good with concrete patterns named, though the description leans toward architectural concepts rather than discrete actions. Trigger term coverage is solid but could benefit from more natural/colloquial user phrases alongside the technical terminology.

  Content: 64%
    conciseness: 3/5 - The skill is mostly efficient but includes some unnecessary framing (e.g., 'Overview' section explaining what evaluation patterns are, 'When to Use' section listing obvious use cases). The code examples are reasonably tight but some explanatory text could be trimmed since Claude understands these concepts.
    actionability: 4/5 - Provides concrete, mostly executable Python code patterns with clear class structures and function signatures. Minor gaps: the `llm()` and `run_tests()` helper functions are undefined, and the code is more illustrative than truly copy-paste ready, but the patterns are concrete enough to adapt immediately.
    workflow_clarity: 4/5 - The refinement loops are clearly sequenced with iteration limits and convergence checks (score thresholds, all-pass checks). The Quick Start Checklist adds good structure. Minor gap: no explicit guidance on what to do when max iterations are exhausted without convergence (fallback behavior), and error handling for parse failures is mentioned but not shown.
    progressive_disclosure: 3/5 - The content is well-sectioned with clear headers and a logical progression from simple to complex patterns. However, at ~150 lines with multiple full code examples, some content (e.g., the evaluation strategies section or the code reflector) could be split into separate reference files. No bundle files exist, and no references to external files are made, so everything is inlined in a single document.

    Assessment: This is a solid, well-structured skill that provides concrete patterns for agentic evaluation with executable Python examples. Its main weaknesses are moderate verbosity in framing sections that explain concepts Claude already understands, and all content being inlined in a single file when the volume of code examples would benefit from progressive disclosure into separate files. The workflow patterns are clear with appropriate iteration limits and convergence checks.

    Suggestions:
      - Trim the Overview and 'When to Use' sections—Claude already understands when evaluation patterns are useful; jump straight to the patterns.
      - Split evaluation strategies (outcome-based, LLM-as-judge, rubric-based) into a separate STRATEGIES.md file and reference it from the main skill.
      - Add explicit fallback/error handling code for when max iterations are exhausted or when JSON parsing of critique results fails, rather than just mentioning it in the checklist.

  Review Score: 79%
```
better-auth/better-icons
vercel-labs/skills/find-skills (but config to use `gh skill` instead)
-> https://www.skillleaderboard.com/ | https://sickn33.github.io/agentic-awesome-skills/ | https://www.skills.sh/
herdrdev/herdr - avail to all
https://github.com/tw93/waza

Leonxlnx/taste-skill

| Skill | Path | Agents | Source |
| --- | --- | --- | --- |
| **cleanup-after-merge** | `~/.agents/skills/cleanup-after-merge` | Codex, Cursor, Gemini CLI, GitHub Copilot, OpenCode +1 more | `local` |
| **graphify** | `~/.codex/skills/graphify` | Codex, OpenCode, Pi | `local` |
| **clonedeps** | `~/.config/opencode/skills/clonedeps` | OpenCode | `local` |
| **codemap** | `~/.config/opencode/skills/codemap` | OpenCode | `local` |
| **simplify** | `~/.config/opencode/skills/simplify` | OpenCode | `local` |

matt-pocock
pstack
