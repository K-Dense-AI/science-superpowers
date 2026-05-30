# Science Superpowers

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/Skills-15-brightgreen.svg)](#whats-inside)
[![Follow on X](https://img.shields.io/badge/Follow_on_X-%40k__dense__ai-000000?logo=x)](https://x.com/k_dense_ai)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-K--Dense_Inc.-0A66C2?logo=linkedin)](https://www.linkedin.com/company/k-dense-inc)
[![YouTube](https://img.shields.io/badge/YouTube-K--Dense_Inc.-FF0000?logo=youtube)](https://www.youtube.com/@K-Dense-Inc)

Science Superpowers is a complete computational-science methodology for your research agents, built on a set of composable skills plus initial instructions that make sure your agent actually uses them. It has **zero third-party dependencies** — it runs with only your agent harness and a POSIX shell.

> ⭐ **If Science Superpowers helps your research, please [star this repository](https://github.com/K-Dense-AI/science-superpowers).** A star helps other scientists and engineers find the project and tells us the methodology is worth expanding.
>
> **Stay up to date:** Follow K-Dense on [X](https://x.com/k_dense_ai), [LinkedIn](https://www.linkedin.com/company/k-dense-inc), and [YouTube](https://www.youtube.com/@K-Dense-Inc) for new skills, release announcements, and research workflow demos.

It is a reimplementation of [Superpowers](https://github.com/obra/superpowers) (a software-development methodology) for a different domain: doing science with data. The architecture is the same — skills that auto-trigger via a session-start bootstrap — but the workflow is the research lifecycle, and the central discipline is **pre-registration** instead of test-driven development.

## Contents

- [How it works](#how-it-works)
- [The basic workflow](#the-basic-workflow)
- [Example: what using it looks like](#example-what-using-it-looks-like)
- [What's inside](#whats-inside)
- [Philosophy](#philosophy)
- [Installation](#installation)
- [Contributing](#contributing)
- [License](#license)
- [Star history](#star-history)

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

**Planning & pre-registration**
- **[designing-the-analysis](skills/designing-the-analysis/SKILL.md)** — Detailed, bite-sized analysis plan
- **[preregistering-analysis](skills/preregistering-analysis/SKILL.md)** — Lock predictions and decision rules before seeing outcomes (includes statistical-fallacies reference)

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

## Installation

Installation differs by harness. If you use more than one, install Science Superpowers separately for each.

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

### Google Antigravity

Antigravity natively supports Agent Skills (the same `SKILL.md` format) and reads `GEMINI.md` / `AGENTS.md` / `.agent/rules/` as always-on rules at session start. Install the skills and load the bootstrap rule — see [.antigravity/INSTALL.md](.antigravity/INSTALL.md).

## Contributing

See `AGENTS.md` / `CLAUDE.md` for contributor guidelines, and `skills/writing-science-skills/SKILL.md` for the complete guide to creating and testing skills.

## License

MIT License — see the [LICENSE](LICENSE) file. This project reimplements the architecture of [Superpowers](https://github.com/obra/superpowers) by Jesse Vincent; see [NOTICE](NOTICE) for attribution details.

## Star history

<a href="https://www.star-history.com/?repos=K-Dense-AI%2Fscience-superpowers&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=K-Dense-AI/science-superpowers&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=K-Dense-AI/science-superpowers&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=K-Dense-AI/science-superpowers&type=date&legend=top-left" />
 </picture>
</a>
