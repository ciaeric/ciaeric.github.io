Run both review agents IN PARALLEL on the most recently written post (or the post path I specify).

## Subagent 1 — Sage (Logic Reviewer)
Follow `ai-workflow/agents/logic-reviewer.md` exactly.
- Identify the post type (solution or opinion)
- Apply the matching review criteria
- Return a report in the format specified in that file

## Subagent 2 — Oracle (Fact Checker)
Follow `ai-workflow/agents/fact-checker.md` exactly.
- Extract all technical and factual claims
- Web search each non-obvious claim against official docs
- Return a report in the format specified in that file

## Output
Present both reports clearly separated with their agent names.

Then give an overall recommendation:
- **Approve** — ready to publish as-is
- **Minor fixes** — small issues only, list exactly what to change
- **Rework needed** — significant issues found, explain what and why
