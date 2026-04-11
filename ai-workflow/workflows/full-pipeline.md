# Workflow: Full Pipeline

End-to-end flow from topic idea to live post on ciaeric.github.io.

## Pipeline Overview

```
[You] give topic
      │
      ▼
  /write-post          ← content-writer agent
      │
      ▼
  /review              ← logic-reviewer + fact-checker run in parallel
      │
      ▼
  [You] approve / request changes
      │
      ▼
  /publish             ← git commit + push → GitHub Pages deploys automatically
```

---

## Step 1 — Write
**Command:** `/write-post`  
**Agent:** [content-writer](../agents/content-writer.md)  
**What happens:**
- Reads existing posts for style reference
- Researches topic via web search
- Drafts post using [blog-post prompt](../prompts/blog-post.md)
- Sources image using [image-generation prompt](../prompts/image-generation.md)
- Saves post to `_posts/` and image to `assets/img/`

---

## Step 2 — Review
**Command:** `/review`  
**Agents:** [logic-reviewer](../agents/logic-reviewer.md) + [fact-checker](../agents/fact-checker.md) (parallel)  
**What happens:**
- Logic reviewer checks structure, flow, clarity, audience fit
- Fact checker web-searches key technical claims
- Both return structured reports for your review

---

## Step 3 — Human Approval
**No command — this is your decision point.**  
Read both review reports. Either:
- Approve → proceed to Step 4
- Request changes → tell Claude what to fix, re-run `/review` when ready

---

## Step 4 — Publish
**Command:** `/publish`  
**Script:** [scripts/publish.sh](../scripts/publish.sh)  
**What happens:**
- `git add` the new post and image
- `git commit` with a descriptive message
- `git push` to master → GitHub Pages auto-deploys (usually live within 1-2 min)
