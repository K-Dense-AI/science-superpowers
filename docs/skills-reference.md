# Skills reference

[Documentation](README.md) · [Research workflow](research-workflow.md)

The library contains 16 skills. Names below link to their source; request them as
`science-superpowers:<name>`. The descriptions here help readers navigate. Agents
should load the full skill when its trigger applies.

## Framing and planning

| Skill | When it applies | Main artifact or handoff |
| --- | --- | --- |
| [science-superpowers:framing-research-questions](../skills/framing-research-questions/SKILL.md) | Before an investigation or data analysis | Approved question document; handoff to survey |
| [science-superpowers:surveying-prior-work](../skills/surveying-prior-work/SKILL.md) | After framing; when selecting methods, powering a study, or assessing novelty | Cited prior-work synthesis; handoff to design |
| [science-superpowers:establishing-feasibility-first](../skills/establishing-feasibility-first/SKILL.md) | Computation may be unrunnable; execution of this mode requires explicit opt-in | Feasibility budget, measured probes, exploratory campaign, partner-controlled exit |
| [science-superpowers:designing-the-analysis](../skills/designing-the-analysis/SKILL.md) | An approved question needs an exact analysis plan | Detailed plan; handoff to registration |
| [science-superpowers:preregistering-analysis](../skills/preregistering-analysis/SKILL.md) | Before confirmatory outcomes or a test intended to support a claim | Frozen registration and audit |

## Execution and investigation

| Skill | When it applies | Main artifact or handoff |
| --- | --- | --- |
| [science-superpowers:setting-up-reproducible-analysis](../skills/setting-up-reproducible-analysis/SKILL.md) | Before executing an analysis needing a reproducible workspace | Environment, seeds, input provenance, baseline |
| [science-superpowers:subagent-driven-analysis](../skills/subagent-driven-analysis/SKILL.md) | A frozen plan has mostly independent steps and delegation is available | Validated steps with protocol and rigor reviews |
| [science-superpowers:executing-analysis](../skills/executing-analysis/SKILL.md) | A frozen plan must run inline without subagents | Validated steps and checkpoint reports |
| [science-superpowers:dispatching-parallel-investigations](../skills/dispatching-parallel-investigations/SKILL.md) | Two or more investigations can proceed without shared state or dependencies | Independent findings reviewed and integrated |
| [science-superpowers:investigating-anomalous-results](../skills/investigating-anomalous-results/SKILL.md) | Surprising numbers, impossible values, failures, nonconvergence, or failed replication | Reproduced anomaly, tested cause, documented resolution |

## Verification, review, and reporting

| Skill | When it applies | Main artifact or handoff |
| --- | --- | --- |
| [science-superpowers:verifying-results-before-claiming](../skills/verifying-results-before-claiming/SKILL.md) | Before stating a result, completion, reproducibility, or significance | Fresh evidence and inspected outputs |
| [science-superpowers:requesting-red-team-review](../skills/requesting-red-team-review/SKILL.md) | After analysis, before reporting or making a confirmatory claim | Skeptical review of conclusions and evidence |
| [science-superpowers:receiving-critical-review](../skills/receiving-critical-review/SKILL.md) | Before acting on methodological feedback | Verified response, justified changes or pushback |
| [science-superpowers:reporting-and-archiving-findings](../skills/reporting-and-archiving-findings/SKILL.md) | Work is complete and verified | Report, reproduction archive, partner's disposition choice |

## The skill system

| Skill | When it applies | Main artifact or handoff |
| --- | --- | --- |
| [science-superpowers:using-science-superpowers](../skills/using-science-superpowers/SKILL.md) | At conversation start | Bootstrap instructions for discovering and invoking relevant skills |
| [science-superpowers:writing-science-skills](../skills/writing-science-skills/SKILL.md) | Creating, changing, or validating a skill | Observed baseline failure, tested intervention, regression scenarios |

## Supporting resources

- Pre-registration: [command-line helper](../skills/preregistering-analysis/prereg.sh),
  [statistical fallacies](../skills/preregistering-analysis/statistical-fallacies.md),
  and the [user guide](preregistration.md).
- Per-step delegation: [analyst prompt](../skills/subagent-driven-analysis/analyst-prompt.md),
  [protocol reviewer prompt](../skills/subagent-driven-analysis/protocol-compliance-reviewer-prompt.md),
  and [rigor reviewer prompt](../skills/subagent-driven-analysis/rigor-reviewer-prompt.md).
- Whole-result review: [reviewer prompt](../skills/requesting-red-team-review/reviewer.md).
- Tool adaptation: [Codex](../skills/using-science-superpowers/references/codex-tools.md),
  [Gemini CLI](../skills/using-science-superpowers/references/gemini-tools.md),
  [Copilot CLI](../skills/using-science-superpowers/references/copilot-tools.md),
  [Antigravity](../skills/using-science-superpowers/references/antigravity-tools.md),
  and [Pi](../skills/using-science-superpowers/references/pi-tools.md).

Tool mappings describe how to translate skill terminology. The harness still
determines which tools are available; a mapping does not install a capability.
