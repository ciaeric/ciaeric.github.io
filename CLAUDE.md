# CLAUDE.md

Project-level instructions for Claude Code when working in ciaeric.github.io.

## About This Project

Jekyll blog hosted on GitHub Pages at ciaeric.github.io. Content is data/analytics focused (Power BI, Databricks, dbt, Python, SQL). The AI workflow in `ai-workflow/` is used to write, review, and publish posts.

## Blog Post Conventions

### Filename
`_posts/YYYY-MM-DD-slug.md`

### Image Folder
Each post gets its own numbered folder: `assets/img/postN/`  
- Next available number: check existing folders in `assets/img/` and use max(N) + 1  
- Current highest: post23 → next is **post24**

Each folder contains exactly two images:
- `avatar.png` — square thumbnail (~400×400), shown in the blog post list
- `socialshare.png` — wide image (~1200×630), used for social sharing (og:image)

### Front Matter (exact format)
```yaml
---
layout: post
title: ""
subtitle: ""
share-img: /assets/img/postN/socialshare.png
thumbnail-img: /assets/img/postN/avatar.png
tags:
- Tag1
- Tag2
published: true
category: blog
---
```

### Post Body Structure
1. Conversational intro (2-3 sentences) connecting topic to a relatable challenge
2. Embed the social share image: `![socialshare](/assets/img/postN/socialshare.png)`
3. `### Challenges This Solution Addresses:` — bullet points with **bold** headers per challenge
4. `### Solution Logic Explained:` — numbered overview of the approach
5. `### Step N: [Title]` — one section per step with code and explanation
6. `### Summary` — brief recap
7. Sign-off: `Happy data engineering!\n\nEric`

### Writing Style
- Direct and technical — written by a practitioner for practitioners
- No fluff, no filler sentences
- Bold key terms within bullet points: `- **Term:** explanation`
- Code blocks with language specifier where possible
- Tables for structured comparisons
- `$~$` for vertical spacing between bullet points when needed

## AI Workflow

Full pipeline docs: [ai-workflow/README.md](ai-workflow/README.md)  
Commands: `/write-post`, `/review`, `/publish`
