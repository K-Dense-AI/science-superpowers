# Science Superpowers

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/Skills-16-brightgreen.svg)](#whats-inside)
[![Agent Plugins](https://img.shields.io/badge/Agent_Plugins-v1.0.0-6E56CF.svg)](https://agent-plugins.org/)
[![Follow on X](https://img.shields.io/badge/Follow_on_X-%40k__dense__ai-000000?logo=x)](https://x.com/k_dense_ai)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-K--Dense_Inc.-0A66C2?logo=linkedin)](https://www.linkedin.com/company/k-dense-inc)
[![YouTube](https://img.shields.io/badge/YouTube-K--Dense_Inc.-FF0000?logo=youtube)](https://www.youtube.com/@K-Dense-Inc)

Science Superpowers is a complete computational-science methodology for your research agents, built on a set of composable skills plus initial instructions that make sure your agent actually uses them. It has **zero third-party dependencies** — it runs with only your agent harness and a POSIX shell.

> ⭐ **If Science Superpowers helps your research, please [star this repository](https://github.com/K-Dense-AI/science-superpowers).** A star helps other scientists and engineers find the project and tells us the methodology is worth expanding.
>
> **Learn more:** [Introducing Science Superpowers](https://www.k-dense.ai/blog/introducing-science-superpowers) — why we built it, the Iron Law, and the full workflow. Related essays are collected under [From the blog](#from-the-blog).
>
> **Stay up to date:** Follow K-Dense on [X](https://x.com/k_dense_ai), [LinkedIn](https://www.linkedin.com/company/k-dense-inc), and [YouTube](https://www.youtube.com/@K-Dense-Inc) for new skills, release announcements, and research workflow demos.

> 🎬 **Prefer to watch first?** [Getting Started with Scientific Agent Skills](https://youtu.be/ZxbnDaD_FVg) covers how skills plug into your agent, and [Skills 101](https://youtu.be/lVZbHiwzMEg) walks through writing one yourself.

It is a reimplementation of [Superpowers](https://github.com/obra/superpowers) (a software-development methodology) for a different domain: doing science with data. The architecture is the same — skills that auto-trigger via a session-start bootstrap — but the workflow is the research lifecycle, and the central discipline is **pre-registration** instead of test-driven development.

## Contents

- [How it works](#how-it-works)
- [The basic workflow](#the-basic-workflow)
- [Example: what using it looks like](#example-what-using-it-looks-like)
- [What's inside](#whats-inside)
- [Philosophy](#philosophy)
- [From the blog](#from-the-blog)
- [Installation](#installation)
- [Contributing](#contributing)
- [License](#license)
- [Star History](#star-history)

## How it works

It starts the moment you fire up your agent. As soon as it sees you're trying to investigate something, it *doesn't* jump straight into running code on your data. Instead it steps back and helps you turn a fuzzy interest into a precise, falsifiable question.

Once the question is clear, it grounds the work in prior literature and standard methods, designs the analysis, and **pre-registers** the hypotheses, predictions, and decision rules *before looking at the outcomes*. That separation — confirmatory vs. exploratory, predictions locked before data — is what protects the work from p-hacking and HARKing (hypothesizing after results are known).

Then it executes the pre-registered plan in a reproducible workspace (pinned environment, fixed seeds, immutable raw data), investigates anomalies by root cause instead of quietly dropping inconvenient data, verifies every claim against fresh reproduced evidence, and red-teams the result before reporting it.

Because the skills trigger automatically, you don't need to do anything special. Your research agent just has Science Superpowers.

## The basic workflow

1. **framing-research-questions** — Activates before any analysis. Turns a rough interest into a precise, falsifiable question with hypotheses, the data needed, and what would count as an answer. Saves a question document.
2. **surveying-prior-work** — Grounds the question and chosen methods in what's already known: standard methods, known confounds, prior effect sizes.
3. **designing-the-analysis** — Breaks the work into bite-sized analysis steps with exact datasets, variables, models/tests, power, and decision rules.
4. **preregistering-analysis** — The Iron Law. Locks hypotheses, directional predictions, and decision rules — and the confirmatory/exploratory split — before any outcome is seen.
5. **setting-up-reproducible-analysis** — Isolated, reproducible workspace: pinned environment, fixed seeds, immutable raw data, clean baseline.
6. **subagent-driven-analysis** or **executing-analysis** — Carries out the pre-registered plan with review checkpoints.
7. **investigating-anomalous-results** — Activates when results look wrong. Root-cause investigation before any adjustment.
8. **verifying-results-before-claiming** — Evidence before claims: re-run, check assumptions, robustness, reproduce.
9. **requesting-red-team-review** / **receiving-critical-review** — Adversarial review before you believe or report a result.
10. **reporting-and-archiving-findings** — Reproducibility check, then write-up/preprint/iterate/shelve/discard, then archive code + data + environment.

**The agent checks for relevant skills before any task.** Mandatory workflows, not suggestions.

### Feasibility mode (opt-in)

The sequence above assumes the analysis *can* be run. When that is the open question — an unbenchmarked solver, a simulation that has never assembled at full size, a memory ceiling nobody has measured — paying for the full sequence first means writing plans and predictions for a study that may not exist.

For that case the agent will *offer* **establishing-feasibility-first**: a minimal end-to-end runner, three scaling probes against a budget whose kill criteria are proven to fire, then one exploratory campaign — deferring the survey, plan, and pre-registration until the measured answer is in.

It is **opt-in and opt-out by you alone**. The agent never enters the mode on its own initiative, never leaves it on its own initiative, and nothing produced inside it can be reported as confirmatory. Pre-registration is deferred, not cancelled: the exit gate hands back to the standard sequence at full strength, with the feasibility measurements as inputs to the design and the exploratory results as hypotheses rather than evidence.

## Example: what using it looks like

You don't invoke anything. You just talk to your agent like normal — the skills trigger themselves.

> **You:** I have last quarter's churn data. Does our new onboarding flow reduce churn?

A vanilla agent would load the CSV and start slicing. With Science Superpowers, the agent steps back first:

> **Agent:** Before touching the data, let me frame this precisely (`framing-research-questions`). The question is whether the new onboarding flow *causes* lower 90-day churn — but users weren't randomly assigned to it, so cohort and seasonality are confounders. Here's the falsifiable version, the data we'd need, and what would count as an answer…
>
> *[surveys prior internal analyses and standard methods, then designs the analysis]*
>
> **Agent:** I'm now **pre-registering** the hypothesis, the directional prediction (new flow → lower churn), and the decision rule **before** I look at any outcome (`preregistering-analysis`). Everything beyond this that wasn't pre-registered will be labeled exploratory.
>
> *[runs the pre-registered plan in a pinned, seeded, reproducible workspace; an anomaly appears]*
>
> **Agent:** One cohort shows implausibly low churn. Rather than dropping it, I'm root-causing it (`investigating-anomalous-results`) — it turns out to be a logging gap, not a real effect.
>
> *[verifies every claim against freshly reproduced output, then red-teams its own conclusion before reporting]*

The result is an analysis where the confirmatory claims are protected from p-hacking and HARKing, the anomalies were explained rather than hidden, and every number can be reproduced.

## What's inside

### Skills library

**Framing**
- **[framing-research-questions](skills/framing-research-questions/SKILL.md)** — Turn an interest into a falsifiable question (entry gate)
- **[surveying-prior-work](skills/surveying-prior-work/SKILL.md)** — Ground the question and methods in existing literature
- **[establishing-feasibility-first](skills/establishing-feasibility-first/SKILL.md)** — Opt-in exploratory/feasibility mode: prove the computation runs at scale before paying for process

**Planning & pre-registration**
- **[designing-the-analysis](skills/designing-the-analysis/SKILL.md)** — Detailed, bite-sized analysis plan
- **[preregistering-analysis](skills/preregistering-analysis/SKILL.md)** — Lock predictions and decision rules before seeing outcomes (includes a statistical-fallacies reference and `prereg.sh`, a zero-dependency freeze/audit script that proves from git history alone that predictions preceded outputs and were never edited after the freeze)

**Execution**
- **[subagent-driven-analysis](skills/subagent-driven-analysis/SKILL.md)** — Fresh subagent per analysis step with two-stage review
- **[executing-analysis](skills/executing-analysis/SKILL.md)** — Inline batch execution with checkpoints
- **[dispatching-parallel-investigations](skills/dispatching-parallel-investigations/SKILL.md)** — Concurrent independent investigations

**Discipline**
- **[investigating-anomalous-results](skills/investigating-anomalous-results/SKILL.md)** — 4-phase root-cause process for surprising results
- **[verifying-results-before-claiming](skills/verifying-results-before-claiming/SKILL.md)** — Evidence before claims

**Review**
- **[requesting-red-team-review](skills/requesting-red-team-review/SKILL.md)** — Dispatch a skeptical reviewer to attack the analysis
- **[receiving-critical-review](skills/receiving-critical-review/SKILL.md)** — Respond to critique with rigor, not performative agreement

**Workspace & reporting**
- **[setting-up-reproducible-analysis](skills/setting-up-reproducible-analysis/SKILL.md)** — Isolated, reproducible workspace
- **[reporting-and-archiving-findings](skills/reporting-and-archiving-findings/SKILL.md)** — Decide how to report; archive code, data, environment

**Meta**
- **[writing-science-skills](skills/writing-science-skills/SKILL.md)** — Create new skills following the testing methodology
- **[using-science-superpowers](skills/using-science-superpowers/SKILL.md)** — Introduction to the skills system

## Philosophy

- **Pre-registration** — State predictions and decision rules before seeing outcomes
- **Confirmatory vs. exploratory** — Always labeled, never blurred
- **Reproducibility** — Pinned environments, fixed seeds, immutable raw data
- **Evidence over claims** — Verify before declaring a finding
- **Root cause over patching** — Investigate anomalies; don't quietly drop data

## From the blog

Essays from the [K-Dense blog](https://www.k-dense.ai/blog) on this methodology and the problems it is built to solve.

**This project**
- **[Introducing Science Superpowers](https://www.k-dense.ai/blog/introducing-science-superpowers)** (May 28, 2026) — Why we built it, the Iron Law, and the full workflow: pre-registration over TDD.
- **[Your AI Assistant Reasons Like a Generalist. Science Needs a Specialist.](https://www.k-dense.ai/blog/introducing-scientific-agents)** (June 2, 2026) — Companion open-source `AGENTS.md` profiles; names Science Superpowers as the methodology layer that puts pre-registration ahead of trial and error.

**Why discipline, not a smarter model**
- **[AI Co-Scientist, Not AI Scientist: Why the Name Matters](https://www.k-dense.ai/blog/ai-co-scientist-not-ai-scientist)** (May 5, 2026) — Keep the human scientist front and center; the agent is a partner, not a replacement.
- **[The AI Co-Scientist Is Here. The Bottleneck Is Verification.](https://www.k-dense.ai/blog/ai-co-scientist-verification-bottleneck)** (June 3, 2026) — Power is not the open question; whether the work is verifiable is.
- **[The Model Is No Longer the Bottleneck](https://www.k-dense.ai/blog/the-model-is-no-longer-the-bottleneck)** (June 7, 2026) — Capability has moved; the remaining bottleneck is the workflow around the model.
- **[The Week Science Models Became Real](https://www.k-dense.ai/blog/frontier-science-models-arrive)** (June 12, 2026) — Frontier models entered scientific workflows; the next bottleneck is evidence.
- **[Reproduction, Not Generation, Is AI's Killer App for Science](https://www.k-dense.ai/blog/reproduction-not-generation-ai-for-science)** (June 16, 2026) — Agents that reproduce published findings matter more than agents that generate unchecked claims.
- **[AI Scientists Need Lab Escape Rooms, Not More Exams](https://www.k-dense.ai/blog/science-needs-better-black-boxes)** (June 29, 2026) — Benchmarks should demand real evidence, not science theater.

**How agent skills work**
- **[Agent Skills: The Final Piece for AI-Powered Scientific Research](https://www.k-dense.ai/blog/agent-skills-final-piece-for-ai-powered-research)** (January 13, 2026) — Why composable skills close the gap between raw model intelligence and domain expertise.

## Installation

Installation differs by harness. If you use more than one, install Science Superpowers separately for each.

### Agent Plugins (any conformant client)

This repository is a valid [Agent Plugins](https://agent-plugins.org/) v1.0.0 package — the open, vendor-neutral plugin standard. The portable manifest is `plugin.json` at the repository root, and the sixteen skills are the immediate children of `skills/`, each with its own `SKILL.md`.

Any client that implements the specification can install Science Superpowers by pointing at this repository; no harness-specific configuration is required for the skills themselves. Bootstrap hooks remain client-specific — see the sections below for the harness you use, or invoke the `using-science-superpowers` skill manually at the start of a session.

### Cursor

In Cursor Agent chat, install from the plugin marketplace, or point Cursor at this repository as a plugin. The `sessionStart` hook (`hooks/hooks-cursor.json`) loads the bootstrap automatically.

### Claude Code

Register a marketplace pointing at this repo (`.claude-plugin/marketplace.json`) and install the `science-superpowers` plugin. The `SessionStart` hook (`hooks/hooks.json`) loads the bootstrap.

### Codex

Use the committed Codex manifest at `.codex-plugin/plugin.json`.

### Gemini CLI

Install as an extension; `gemini-extension.json` points the context file at `GEMINI.md`, which loads the bootstrap and the Gemini tool mapping.

### OpenCode

See [.opencode/INSTALL.md](.opencode/INSTALL.md).

### Pi

Pi natively reads the same `SKILL.md` format. Install the package with
`pi install git:github.com/K-Dense-AI/science-superpowers`; the `package.json` `pi` key
registers the skills and a `before_agent_start` extension loads the bootstrap. See
[.pi/INSTALL.md](.pi/INSTALL.md).

### Google Antigravity

Antigravity natively supports Agent Skills (the same `SKILL.md` format) and reads `GEMINI.md` / `AGENTS.md` / `.agent/rules/` as always-on rules at session start. Install the skills and load the bootstrap rule — see [.antigravity/INSTALL.md](.antigravity/INSTALL.md).

## Contributing

See `AGENTS.md` / `CLAUDE.md` for contributor guidelines, and `skills/writing-science-skills/SKILL.md` for the complete guide to creating and testing skills.

## License

MIT License — see the LICENSE file. This project reimplements the architecture of [Superpowers](https://github.com/obra/superpowers) by Jesse Vincent.

## Star History

<a href="https://star-history.dera.page/#K-Dense-AI/science-superpowers">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://star-history.dera.page/svg?repos=K-Dense-AI/science-superpowers&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://star-history.dera.page/svg?repos=K-Dense-AI/science-superpowers" />
   <img alt="Star History Chart" src="https://star-history.dera.page/svg?repos=K-Dense-AI/science-superpowers" />
 </picture>
</a>
