---
layout: post
title: "Stop. Understand Your Business Process Before You Build an AI Agent"
subtitle: "Treating agents like employees means giving them a job description first"
share-img: /assets/img/post24/socialshare.png
thumbnail-img: /assets/img/post24/avatar.png
tags:
- AI Agents
- Business Process
- Data Engineering
published: true
category: blog
---

![socialshare](/assets/img/post24/socialshare.png)

AI agents are everywhere right now. Every team wants one. Every vendor is selling one. And almost everyone is deploying them in the wrong order.

The conversation usually goes: "We have this problem — let's build an agent to solve it." What comes next is weeks of prompt tuning, escalating API costs, and an agent that half-works at best. Sound familiar? It should. 80% of AI agent projects fail to reach production, and 92% of those that do experience cost overruns averaging 340% above estimates. The models aren't the problem. The missing business process understanding is.

---

I've watched the same pattern play out with Power BI, with data pipelines, and now with agents. When a new technology gets a "self-service" label attached to it, people assume the hard thinking has been done for them. It hasn't.

An agent is not a magic box you point at a problem. It is a worker. And like any worker, it will perform exactly as well as the clarity of its job description. No more, no less.

Would you hire a developer and say "figure it out"? Of course not. You'd give them requirements, acceptance criteria, a definition of done. You'd define what decisions they're empowered to make and which ones they need to escalate. You'd tell them what "good" looks like. Unclear requirements end in disaster — every developer knows this. Agents are no different.

---

The right sequence is not: **problem → agent**. It is: **problem → process → decisions → standards → agent**.

Before you write a single line of agent code or craft a single prompt, you need to map the business process you're trying to automate. Walk through every step. For each step, ask:

- What decision is being made here?
- What data is needed to make that decision?
- What are the rules, thresholds, and exceptions?
- What does a wrong decision cost?

Only once you can answer those questions clearly do you know what skills the agent needs, what tools it should have access to, what it should escalate, and what it should never touch. McKinsey found that organisations pursuing enterprise-level AI transformation are **3.6x more likely** to redesign workflows end-to-end rather than simply automate existing steps as-is — and that workflow redesign is consistently the dividing line between implementations that generate ROI and those that don't.

---

The cost argument alone should be enough to slow people down. Model inference is only about 20% of the total cost of running an agent in production — the remainder is retries, orchestration overhead, and engineering time, based on production cost analyses of enterprise agentic deployments. The rest is retries, wasted tokens, subagent calls triggered by ambiguous instructions, and engineering time spent debugging behaviour that was never defined properly in the first place. Identical tasks can generate wildly different numbers of model calls depending on how well the process was specified upfront.

A retail team deployed a shopping agent that failed in production because it was pulling inventory data from 47 Excel files that hadn't been updated since 2022 — a pattern documented across multiple 2025 production failure case studies. Nobody mapped the data dependencies before building the agent. The process wasn't understood. The agent was blamed.

---

My suggestion: before your team ships an agent, you should be able to fill in this one-pager:

1. **Process:** What is the end-to-end process this agent participates in?
2. **Trigger:** What starts the agent's work?
3. **Decisions:** What decisions does it make autonomously vs. escalate?
4. **Rules:** What constraints and standards must it follow?
5. **Skills:** What tools does it need (search, read, write, call an API)?
6. **Done state:** How do you know it finished correctly?
7. **Failure mode:** What does it do when something goes wrong?

If you can't answer all seven, you're not ready to build the agent. You're ready to do more process work.

Agents are powerful. But like every powerful tool, they amplify both good and bad process design. Get the process right first, and the agent becomes a force multiplier. Skip it, and you'll spend three months and a very large bill discovering what you should have mapped on a whiteboard in an afternoon.

Thanks

Eric Dong

---
*Drafted by **Quill**, reviewed by **Sage** and **Oracle** — the AI agents behind this post.*
