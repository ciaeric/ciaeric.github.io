# Agents

Each agent is a named, autonomous role with a specific job in the pipeline.

| Agent | Name | File | Role |
|-------|------|------|------|
| Content Writer | **Quill** | [content-writer.md](content-writer.md) | Researches, writes, and sources images |
| Logic Reviewer | **Sage** | [logic-reviewer.md](logic-reviewer.md) | Reviews structure, flow, and clarity |
| Fact Checker | **Oracle** | [fact-checker.md](fact-checker.md) | Verifies technical accuracy via web search |

## Pipeline

```
Quill writes draft
      │
      ├──► Sage reviews logic    ─┐
      │                           ├─► findings → you approve → publish
      └──► Oracle checks facts   ─┘
```

Sage and Oracle run in parallel after the draft is ready.

## Agent vs Prompt

| | Prompt | Agent |
|---|--------|-------|
| Nature | Static text template | Autonomous named role |
| Tools | None | Read, WebSearch, Bash, Write |
| Steps | Single | Multi-step until done |
| Output | Text | Actions + structured report |
