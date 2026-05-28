---
name: requesting-red-team-review
description: Use after completing an analysis or before reporting a finding, to have a skeptical reviewer attack the conclusion before you believe it
---

# Requesting Red-Team Review

Dispatch a reviewer subagent whose explicit job is to find why your conclusion is wrong — before you believe it or report it. The reviewer gets precisely crafted context for evaluation, never your session's history. This keeps it focused on the work product and your reasoning, not on agreeing with you, and preserves your own context.

**Core principle:** Try hardest to break a finding when it's most likely to be right. A result that survives a genuine attack is worth reporting; one that hasn't been attacked isn't.

## When to Request Review

**Mandatory:**
- After each analysis step in subagent-driven-analysis (the rigor reviewer plays this role per step)
- After completing the full analysis, before writing it up
- Before claiming any confirmatory finding

**Especially valuable:**
- When the result is surprising, important, or convenient
- When performance is suspiciously good (possible leakage)
- After resolving an anomaly

## How to Request

**1. Get the git SHAs that bound the work:**
```bash
BASE_SHA=$(git rev-parse HEAD~N)   # before the analysis
HEAD_SHA=$(git rev-parse HEAD)
```

**2. Dispatch the reviewer subagent** with the Task tool (general-purpose), filling the template at `reviewer.md`.

**Placeholders:**
- `{DESCRIPTION}` — what you analyzed and the conclusion you're considering
- `{QUESTION}` — the research question
- `{PREREGISTRATION}` — the frozen pre-registration (or note that this is exploratory)
- `{BASE_SHA}` / `{HEAD_SHA}` — commit range

**3. Act on feedback:**
- Fix Critical issues (a confound, leakage, an assumption violation that changes the conclusion) before claiming anything
- Address Important issues before reporting
- Note Minor issues
- Push back with reasoning if the reviewer is wrong — but verify first

## What the Reviewer Attacks

The reviewer is prompted to look for:
- **Confounds and alternative explanations** — what else could produce this result?
- **Assumption violations** — does the method fit the data?
- **Data leakage** — did test information contaminate the result?
- **Researcher degrees of freedom** — signs of p-hacking, HARKing, or post-hoc choices
- **Multiplicity** — uncorrected multiple comparisons
- **Reproducibility** — does it reproduce from raw + seed?
- **Over-claiming** — does the conclusion outrun the evidence (causal language from observational data, generalizing beyond the sample)?

## Example

```
[Completed primary analysis: exposure → outcome, pre-registered]

You: Requesting red-team review before I report this.

BASE_SHA=a1b2c3d  HEAD_SHA=e4f5g6h
[Dispatch reviewer subagent with reviewer.md filled in]

Reviewer returns:
  Critical: Site is associated with both exposure and outcome but isn't in the model — likely confound (Simpson's risk).
  Important: No check of the homoscedasticity assumption.
  Minor: Figure axis unlabeled.

You: [Site WAS pre-registered as a covariate — verify the model actually included it]
[Check: the model formula dropped `site` due to a typo. Reviewer is right. Fix, re-run, re-verify.]
```

## Red Flags

**Never:**
- Skip review because the result "is obviously right"
- Ignore a Critical issue
- Report a finding with unresolved Important issues
- Argue with valid methodological feedback

**If the reviewer is wrong:** push back with technical reasoning and show the verification (the diagnostic, the pre-registration line, the reproduced number) — see `science-superpowers:receiving-critical-review`.

## Integration

- **science-superpowers:subagent-driven-analysis** — the per-step rigor review uses this pattern
- **science-superpowers:receiving-critical-review** — how to respond to what the reviewer finds
- **science-superpowers:reporting-and-archiving-findings** — only after the result survives review

See template at: `requesting-red-team-review/reviewer.md`
