# Science Superpowers documentation

Science Superpowers gives research agents a computational-science methodology:
frame a question, ground the design in prior work, freeze predictions before seeing
outcomes, run reproducibly, and challenge the findings before reporting them.

The central rule is **no confirmatory claim without a pre-registered prediction
first**. Exploration is useful; it must remain distinguishable from confirmation.

## Start here

1. [Install for your agent](installation.md) and check that the skills and bootstrap load.
2. [Run your first investigation](getting-started.md) with a concrete starting prompt.
3. [Follow the research workflow](research-workflow.md), including its review gates.
4. [Freeze and audit a pre-registration](preregistration.md) with the bundled shell tool.

## Guides and reference

| Guide | What you will find |
| --- | --- |
| [Getting started](getting-started.md) | What to provide, what the agent should do first, and what a completed investigation includes |
| [Installation](installation.md) | Harness-specific setup, bootstrap behavior, verification, and updates |
| [Research workflow](research-workflow.md) | The standard sequence, feasibility mode, execution choices, and artifact layout |
| [Worked example](examples/solver-comparison.md) | How a solver comparison moves from a vague question to a defensible report |
| [Skills reference](skills-reference.md) | All 16 skills, their triggers, and supporting resources |
| [Pre-registration](preregistration.md) | A runnable freeze/audit walkthrough, command reference, and audit limitations |
| [Troubleshooting](troubleshooting.md) | Missing skills, bootstrap failures, audit failures, and workflow questions |
| [Contributing](contributing.md) | Repository architecture, skill authoring, validation, and version maintenance |

## What is included

The library supplies Markdown skills, harness adapters, and a Git-based
pre-registration helper. It does not install statistical packages, retrieve data,
or provide compute. Those capabilities come from your agent's tools and the
research project's environment. No third-party runtime packages are required by
the library itself; see [requirements](installation.md#requirements) for the shell
and developer-tool details.

These pages explain how to use the library. The executable guidance for agents
lives in each `SKILL.md`; use the [skills reference](skills-reference.md) to find the
source. Study documents written by an agent belong under
`docs/science-superpowers/` in **your research repository**, separate from this
library's documentation.

[Project overview](../README.md) · [Contributor instructions](../AGENTS.md) · [License](../LICENSE)
