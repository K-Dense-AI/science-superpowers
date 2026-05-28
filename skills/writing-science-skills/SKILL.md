---
name: writing-science-skills
description: Use when creating new skills, editing existing skills, or verifying skills work before deployment
---

# Writing Science Skills

## Overview

**Writing a skill is an experiment, not an essay.** You form a hypothesis (this guidance will change agent behavior), run a baseline (watch agents fail without it), write the skill, and test that behavior changes.

**Core principle:** If you didn't watch an agent fail without the skill, you don't know whether the skill teaches the right thing — the same reason you pre-register before analyzing rather than rationalizing a result after.

**REQUIRED BACKGROUND:** Understand `science-superpowers:preregistering-analysis` first. The discipline of fixing a prediction before observing the outcome is exactly the discipline here: observe baseline behavior before writing the skill, so the skill is shaped by evidence, not by what you imagine agents do.

## What is a Skill?

A **skill** is a reference guide for a proven technique, pattern, or discipline that future agents can find and apply.

**Skills are:** reusable techniques, patterns, disciplines, reference guides.

**Skills are NOT:** narratives about how you did something once.

## The Empirical Mapping

| Experiment concept | Skill creation |
|--------------------|----------------|
| Hypothesis | "This guidance will fix behavior X" |
| Baseline / control | Agent behavior WITHOUT the skill |
| Observed failure (the signal) | The exact rationalizations agents use |
| Intervention | The skill document |
| Effect | Agent now complies |
| Replication | Re-test under different pressures until robust |

## When to Create a Skill

**Create when:**
- The technique wasn't obvious and you'd reference it again across projects
- It applies broadly (not project-specific)

**Don't create for:**
- One-off solutions
- Standard practice documented elsewhere
- Project-specific conventions (put those in CLAUDE.md)
- Anything enforceable mechanically (validate it in code instead of documenting a judgment call)

## Skill Types

- **Technique** — a concrete method with steps (e.g., investigating-anomalous-results)
- **Pattern** — a way of thinking (e.g., separating confirmatory from exploratory)
- **Discipline** — a rule that must resist rationalization (e.g., preregistering-analysis)
- **Reference** — API/command/method documentation (e.g., statistical-fallacies)

## Directory Structure

```
skills/
  skill-name/
    SKILL.md              # Main reference (required)
    supporting-file.*     # Only for heavy reference or reusable tools
```

Flat namespace. Keep principles and short patterns inline; split out only heavy reference (100+ lines) or reusable tools/templates.

## SKILL.md Structure

**Frontmatter (YAML):** two required fields, `name` and `description`, max 1024 characters total.
- `name`: letters, numbers, hyphens only
- `description`: third person, describes ONLY WHEN to use (not what it does); start with "Use when..."

### Description = When to Use, NOT What the Skill Does

This is the single most important authoring rule. If the description summarizes the workflow, the agent follows the summary and skips the skill body.

```yaml
# BAD: summarizes workflow — agent follows this instead of reading the skill
description: Use when analyzing data - pre-register, run the test, check assumptions, then report

# GOOD: triggering conditions only
description: Use before running any confirmatory analysis or looking at outcome data
```

Use concrete triggers and symptoms. Describe the *problem* (a convenient result, a surprising number), not just the topic. Keep it technology-agnostic unless the skill is technology-specific.

## Claude Search Optimization (CSO)

Future agents must FIND your skill.
- **Rich description** — the triggering conditions an agent would recognize
- **Keyword coverage** — error messages, symptoms ("leakage", "won't converge", "p-hacked"), synonyms, tool/library names
- **Descriptive, verb-first naming** — `investigating-anomalous-results` not `anomaly-utils`; gerunds work well for processes
- **Token efficiency** — frequently-loaded skills should be tight; move detail to references, use cross-references instead of repetition

## Cross-Referencing Other Skills

Use the skill name with an explicit requirement marker:
- Good: `**REQUIRED SUB-SKILL:** Use science-superpowers:preregistering-analysis`
- Bad: `See skills/.../SKILL.md` (unclear if required)
- Bad: `@skills/.../SKILL.md` (force-loads, burns context)

Never use `@` links to other skills — they load immediately and consume context before it's needed.

## Flowchart Usage

Use a small graphviz `dot` flowchart ONLY for a non-obvious decision point or a loop where the agent might stop too early. Never for reference material (use tables/lists), code (use code blocks), or linear steps (use numbered lists). Keep node labels semantic.

## Code & Examples

One excellent, complete, runnable example beats five mediocre ones. For a computational-science framework, prefer Python for data work and shell for environment/pipeline work. Comment WHY, not what. Don't write fill-in-the-blank templates.

## The Iron Law

```
NO SKILL WITHOUT AN OBSERVED BASELINE FAILURE FIRST
```

Applies to NEW skills AND EDITS. Wrote the skill before observing the baseline? You're guessing at what agents need. Delete it, run the baseline, start over.

**No exceptions** — not for "simple additions", not for "just a section", not for "documentation updates". Don't keep untested changes as "reference".

## Testing All Skill Types

Different types need different tests. Dispatch fresh subagents (no shared context) and observe.

- **Discipline skills** (preregistering-analysis, verifying-results-before-claiming): pressure scenarios — time pressure, a convenient result, sunk cost, authority. Success = agent holds the line under combined pressure. Capture every rationalization and add an explicit counter.
- **Technique skills** (investigating-anomalous-results): application scenarios and edge cases. Success = agent applies the technique correctly to a new case.
- **Pattern skills**: recognition + application + counter-examples. Success = agent knows when it applies and when it doesn't.
- **Reference skills** (statistical-fallacies): retrieval + application. Success = agent finds and correctly uses the right entry.

### RED — GREEN — REFACTOR for Skills

1. **RED (baseline):** run the scenario WITHOUT the skill. Document the exact choices and rationalizations verbatim.
2. **GREEN (minimal skill):** write the skill addressing those specific failures. Re-run; confirm compliance.
3. **REFACTOR (close loopholes):** new rationalization appears? Add an explicit counter. Re-test until robust.

## Bulletproofing Discipline Skills

- **Close every loophole explicitly** — don't just state the rule; forbid the specific workarounds ("Don't relabel the peeked analysis confirmatory").
- **State the foundational principle** — "Violating the letter is violating the spirit" cuts off a whole class of rationalizations.
- **Build a rationalization table** — every excuse from baseline testing, with its reality.
- **Create a Red Flags list** — the thoughts that signal the agent is about to violate the rule.

## Common Rationalizations for Skipping Testing

| Excuse | Reality |
|--------|---------|
| "Skill is obviously clear" | Clear to you ≠ clear to another agent. Test it. |
| "It's just a reference" | References have gaps. Test retrieval. |
| "No time to test" | Deploying an untested skill costs more time later. |
| "Academic review is enough" | Reading ≠ using. Test application. |

## Checklist (use TodoWrite for each item)

**RED:**
- [ ] Write pressure/application scenarios (3+ combined pressures for discipline skills)
- [ ] Run WITHOUT the skill; document baseline verbatim
- [ ] Identify rationalization/failure patterns

**GREEN:**
- [ ] `name` uses only letters/numbers/hyphens
- [ ] `description` starts with "Use when", third person, triggers only, no workflow summary
- [ ] Keywords for search throughout
- [ ] Addresses the specific baseline failures
- [ ] One excellent example
- [ ] Re-run WITH the skill; confirm compliance

**REFACTOR:**
- [ ] Add counters for new rationalizations
- [ ] Rationalization table + Red Flags list
- [ ] Re-test until robust

**Quality:**
- [ ] Small flowchart only if a decision is non-obvious
- [ ] No narrative storytelling
- [ ] Cross-references use `science-superpowers:<name>`, no `@` links
- [ ] Run `scripts/bump-version.sh --check` if you touched a manifest

## STOP: Before Moving to the Next Skill

After writing ANY skill, STOP and complete its testing before starting another. Don't batch. Deploying an untested skill is deploying an untested intervention.

## The Bottom Line

Creating a skill IS running an experiment on agent behavior. Same discipline as pre-registration: observe the baseline before you intervene, and let evidence — not your imagination — shape the result.
