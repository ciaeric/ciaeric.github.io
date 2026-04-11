# Prompt: Blog Post Draft

Used by the content-writer agent (Quill) to generate the initial draft.

There are two post types — use the matching template.

---

## Type 1: Solution / Tip Post

For posts that walk through a technical problem and its solution (e.g. Databricks XML ingestion, dbt nested JSON).

### Variables
- `{{TOPIC}}` — subject of the post
- `{{AUDIENCE}}` — intended reader (e.g., data engineer)
- `{{KEY_POINTS}}` — bullet list of points to cover
- `{{POST_N}}` — post number (e.g., 24)

### Prompt

```
Write a technical solution post about {{TOPIC}} for {{AUDIENCE}}.

Cover these key points:
{{KEY_POINTS}}

Follow this exact structure:

1. Opening (2-3 sentences): Start with a relatable problem or scenario. 
   Conversational but not fluffy. Reference related past work if relevant.

2. Image embed on its own line:
   ![socialshare](/assets/img/post{{POST_N}}/socialshare.png)

3. ### Challenges This Solution Addresses:
   3-4 bullet points. Each bullet: **Bold Title:** 2-3 sentences of explanation.
   Use $~$ between bullets for vertical spacing.

4. ### Solution Logic Explained:
   Numbered overview of the full approach — one sentence per step, no code yet.

5. ### Step 1: [Title] ... ### Step N: [Title]
   One H3 section per step. Show code first, then explain what it does.
   Use language-tagged code blocks (python, sql, bash, etc.).
   Include example output tables where helpful.

6. ### Summary
   2-3 sentences. Recap what was built and why it matters in production.

7. Sign off with exactly:
   Happy data engineering!

   Eric

   ---
   *Drafted by **Quill**, reviewed by **Sage** and **Oracle** — the AI agents behind this post.*

Style rules:
- Direct and technical — no filler
- Bold key terms: **Term:** explanation
- $~$ for spacing between bullet points
- Tables for structured data comparisons
```

---

## Type 2: Opinion / Thought Post

For posts sharing perspective, analysis, or commentary (e.g. "Is Power BI a Self Service Tool?").

### Variables
- `{{TOPIC}}` — the question or thesis
- `{{AUDIENCE}}` — intended reader
- `{{VIEWPOINTS}}` — the key arguments or angles to cover

### Prompt

```
Write an opinion post about {{TOPIC}} for {{AUDIENCE}}.

Cover these viewpoints and arguments:
{{VIEWPOINTS}}

Follow this structure:

1. Opening image embed (if available):
   ![socialshare](/assets/img/post{{POST_N}}/socialshare.png)

2. State the central question or thesis in 1-2 sentences.

3. Explain why this topic matters — what misconception or problem prompted this post?

4. Develop each viewpoint in its own paragraph or short section.
   Use --- horizontal rules to separate major shifts in argument.
   Use inline images if they illustrate a point.

5. Concrete recommendation or call to action in conclusion.

6. Sign off with exactly:
   Thanks

   Eric Dong

   ---
   *Drafted by **Quill**, reviewed by **Sage** and **Oracle** — the AI agents behind this post.*

Style rules:
- First person, direct, opinionated — say what you actually think
- No academic hedging ("it could be argued that...")
- Short paragraphs, conversational
- Back opinions with specific observations from real experience
```
