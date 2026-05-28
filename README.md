# Science Superpowers

Science Superpowers is a complete computational-science methodology for your research agents, built on a set of composable skills plus initial instructions that make sure your agent actually uses them.

It is a reimplementation of [Superpowers](https://github.com/obra/superpowers) (a software-development methodology) for a different domain: doing science with data. The architecture is the same — skills that auto-trigger via a session-start bootstrap — but the workflow is the research lifecycle, and the central discipline is **pre-registration** instead of test-driven development.

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

## What's inside

### Skills library

**Framing**
- **framing-research-questions** — Turn an interest into a falsifiable question (entry gate)
- **surveying-prior-work** — Ground the question and methods in existing literature

**Planning & pre-registration**
- **designing-the-analysis** — Detailed, bite-sized analysis plan
- **preregistering-analysis** — Lock predictions and decision rules before seeing outcomes (includes statistical-fallacies reference)

**Execution**
- **subagent-driven-analysis** — Fresh subagent per analysis step with two-stage review
- **executing-analysis** — Inline batch execution with checkpoints

**Discipline**
- **investigating-anomalous-results** — 4-phase root-cause process for surprising results
- **verifying-results-before-claiming** — Evidence before claims

**Review**
- **requesting-red-team-review** — Dispatch a skeptical reviewer to attack the analysis
- **receiving-critical-review** — Respond to critique with rigor, not performative agreement

**Workspace & reporting**
- **setting-up-reproducible-analysis** — Isolated, reproducible workspace
- **reporting-and-archiving-findings** — Decide how to report; archive code, data, environment
- **dispatching-parallel-investigations** — Concurrent independent investigations

**Meta**
- **writing-science-skills** — Create new skills following the testing methodology
- **using-science-superpowers** — Introduction to the skills system

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

## Contributing

See `AGENTS.md` / `CLAUDE.md` for contributor guidelines, and `skills/writing-science-skills/SKILL.md` for the complete guide to creating and testing skills.

## License

MIT License — see the LICENSE file. This project reimplements the architecture of [Superpowers](https://github.com/obra/superpowers) by Jesse Vincent.
