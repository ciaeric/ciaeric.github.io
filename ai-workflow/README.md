# AI Workflow

AI-assisted pipeline for writing and publishing posts on ciaeric.github.io, powered by Claude Code.

## The Agents

| Name | Role |
|------|------|
| **Quill** | Content writer — researches, drafts, and sources images |
| **Sage** | Logic reviewer — checks structure, flow, and clarity |
| **Oracle** | Fact checker — verifies technical accuracy via web search |

## Pipeline

```
/write-post        /review              you approve      /publish
(Quill drafts  →  (Sage + Oracle    →   (human gate)  →  (git push
 + images)         run in parallel)                        → live)
```

## Post Types

| Type | Structure | Sign-off |
|------|-----------|---------|
| Solution/Tip | Challenges → Solution Logic → Steps → Summary | "Happy data engineering!" |
| Opinion | Thesis → Why it matters → Viewpoints → Recommendation | "Thanks, Eric Dong" |

Both types end with:
> *Drafted by **Quill**, reviewed by **Sage** and **Oracle** — the AI agents behind this post.*

## Commands

| Command | What it does |
|---------|-------------|
| `/write-post` | Quill drafts a new post + sources both images |
| `/review` | Sage (logic) + Oracle (facts) review in parallel |
| `/publish` | Stage, commit, push → site goes live in ~1-2 min |

## Folder Map

```
ai-workflow/
├── agents/
│   ├── content-writer.md   ← Quill spec
│   ├── logic-reviewer.md   ← Sage spec
│   └── fact-checker.md     ← Oracle spec
├── prompts/
│   ├── blog-post.md        ← writing templates (solution + opinion)
│   └── image-generation.md ← image sourcing (Picsum / DALL-E)
├── workflows/
│   └── full-pipeline.md    ← end-to-end process doc
└── scripts/
    └── publish.sh          ← git add + commit + push

.claude/commands/           ← actual Claude Code slash commands
├── write-post.md           → /write-post
├── review.md               → /review
└── publish.md              → /publish
```

## Image Structure Per Post

```
assets/img/postN/
├── avatar.png        (400×400)   — blog list thumbnail
└── socialshare.png   (1200×630)  — social sharing / og:image
```
Next post number: **post24** (check `ls assets/img/ | grep post` to confirm).
