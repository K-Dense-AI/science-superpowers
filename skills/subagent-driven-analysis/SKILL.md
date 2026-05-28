---
name: subagent-driven-analysis
description: Use when executing a pre-registered analysis plan with mostly independent steps in the current session
---

# Subagent-Driven Analysis

Execute a pre-registered analysis plan by dispatching a fresh subagent per analysis step, with two-stage review after each: protocol-compliance review first (did it run exactly what was pre-registered, nothing more), then statistical-rigor review (assumptions, leakage, correctness, reproducibility).

**Why subagents:** You delegate steps to specialized agents with isolated context. By precisely crafting their instructions, you keep them focused and prevent them from improvising analyses you didn't pre-register. They never inherit your session's history — you construct exactly what they need. This also preserves your own context for coordination.

**Core principle:** Fresh subagent per step + two-stage review (protocol then rigor) = trustworthy, reproducible results.

**Continuous execution:** Do not pause to check in between steps. Execute the whole plan. The only reasons to stop: a BLOCKED status you cannot resolve, an anomaly that needs `science-superpowers:investigating-anomalous-results`, a genuine ambiguity, or all steps complete.

## Prerequisite

The analysis plan MUST be pre-registered and frozen (`science-superpowers:preregistering-analysis`) before any step runs. If it is not frozen, stop and pre-register first. Executing before freezing turns the whole thing exploratory.

## When to Use

```dot
digraph when_to_use {
    "Pre-registered plan?" [shape=diamond];
    "Steps mostly independent?" [shape=diamond];
    "Stay in this session?" [shape=diamond];
    "subagent-driven-analysis" [shape=box];
    "executing-analysis" [shape=box];
    "Pre-register first" [shape=box];

    "Pre-registered plan?" -> "Steps mostly independent?" [label="yes"];
    "Pre-registered plan?" -> "Pre-register first" [label="no"];
    "Steps mostly independent?" -> "Stay in this session?" [label="yes"];
    "Stay in this session?" -> "subagent-driven-analysis" [label="yes"];
    "Stay in this session?" -> "executing-analysis" [label="no - parallel session"];
}
```

## The Process

```dot
digraph process {
    rankdir=TB;

    "Set up reproducible workspace" [shape=box];
    "Read plan + frozen prereg, extract all steps, create TodoWrite" [shape=box];
    "Dispatch analyst subagent (./analyst-prompt.md)" [shape=box];
    "Analyst asks questions?" [shape=diamond];
    "Answer, provide context" [shape=box];
    "Analyst runs step, validates, commits, self-reviews" [shape=box];
    "Dispatch protocol-compliance reviewer (./protocol-compliance-reviewer-prompt.md)" [shape=box];
    "Ran exactly the pre-registered analysis?" [shape=diamond];
    "Analyst fixes deviations" [shape=box];
    "Dispatch rigor reviewer (./rigor-reviewer-prompt.md)" [shape=box];
    "Rigor reviewer approves?" [shape=diamond];
    "Analyst fixes rigor issues" [shape=box];
    "Mark step complete" [shape=box];
    "More steps?" [shape=diamond];
    "Use requesting-red-team-review on whole result" [shape=box style=filled fillcolor=lightgreen];
    "Use reporting-and-archiving-findings" [shape=box style=filled fillcolor=lightgreen];

    "Set up reproducible workspace" -> "Read plan + frozen prereg, extract all steps, create TodoWrite";
    "Read plan + frozen prereg, extract all steps, create TodoWrite" -> "Dispatch analyst subagent (./analyst-prompt.md)";
    "Dispatch analyst subagent (./analyst-prompt.md)" -> "Analyst asks questions?";
    "Analyst asks questions?" -> "Answer, provide context" [label="yes"];
    "Answer, provide context" -> "Dispatch analyst subagent (./analyst-prompt.md)";
    "Analyst asks questions?" -> "Analyst runs step, validates, commits, self-reviews" [label="no"];
    "Analyst runs step, validates, commits, self-reviews" -> "Dispatch protocol-compliance reviewer (./protocol-compliance-reviewer-prompt.md)";
    "Dispatch protocol-compliance reviewer (./protocol-compliance-reviewer-prompt.md)" -> "Ran exactly the pre-registered analysis?";
    "Ran exactly the pre-registered analysis?" -> "Analyst fixes deviations" [label="no"];
    "Analyst fixes deviations" -> "Dispatch protocol-compliance reviewer (./protocol-compliance-reviewer-prompt.md)" [label="re-review"];
    "Ran exactly the pre-registered analysis?" -> "Dispatch rigor reviewer (./rigor-reviewer-prompt.md)" [label="yes"];
    "Dispatch rigor reviewer (./rigor-reviewer-prompt.md)" -> "Rigor reviewer approves?";
    "Rigor reviewer approves?" -> "Analyst fixes rigor issues" [label="no"];
    "Analyst fixes rigor issues" -> "Dispatch rigor reviewer (./rigor-reviewer-prompt.md)" [label="re-review"];
    "Rigor reviewer approves?" -> "Mark step complete" [label="yes"];
    "Mark step complete" -> "More steps?";
    "More steps?" -> "Dispatch analyst subagent (./analyst-prompt.md)" [label="yes"];
    "More steps?" -> "Use requesting-red-team-review on whole result" [label="no"];
    "Use requesting-red-team-review on whole result" -> "Use reporting-and-archiving-findings";
}
```

## Model Selection

Use the least powerful model that can handle each role.

- **Mechanical steps** (load data, apply a fixed transform, produce a planned figure): fast, cheap model.
- **Integration/judgment steps** (fitting the primary model, handling missingness per plan): standard model.
- **Rigor review and anomaly judgment**: most capable model.

## Handling Analyst Status

**DONE:** Proceed to protocol-compliance review.

**DONE_WITH_CONCERNS:** Read the concerns. If about correctness or an unexpected data issue, address before review (may need `science-superpowers:investigating-anomalous-results`). If an observation ("this file is getting large"), note and proceed.

**NEEDS_CONTEXT:** Provide the missing information and re-dispatch.

**BLOCKED:** Assess. Context problem → provide more and re-dispatch. Needs more reasoning → more capable model. Step too large → split. Plan itself is wrong → escalate to your human partner. A wrong plan may require re-opening the pre-registration, which must be documented as a deviation.

**Never** silently let a subagent change the registered analysis to make a step "work." A deviation is documented and renders that analysis exploratory.

## Prompt Templates

- `./analyst-prompt.md` — dispatch the analyst subagent
- `./protocol-compliance-reviewer-prompt.md` — did it match the pre-registration?
- `./rigor-reviewer-prompt.md` — is the statistics correct, reproducible, leak-free?

## Red Flags

**Never:**
- Execute before the pre-registration is frozen
- Skip either review (protocol OR rigor)
- Let a subagent add an unregistered analysis and report it as confirmatory
- Run rigor review before protocol compliance is green (wrong order)
- Accept a silently dropped outlier or changed cutoff (route to anomaly investigation instead)
- Dispatch multiple analyst subagents on the same artifacts in parallel (conflicts)
- Make the subagent read the whole plan (provide the step's full text + the relevant pre-registration excerpt)

**If a reviewer finds issues:** the same analyst subagent fixes them, then the reviewer reviews again. Repeat until approved.

## Integration

**Required workflow skills:**
- **science-superpowers:setting-up-reproducible-analysis** — isolated, seeded, reproducible workspace (run first)
- **science-superpowers:preregistering-analysis** — must be frozen before execution
- **science-superpowers:investigating-anomalous-results** — when a step's output is surprising or impossible
- **science-superpowers:requesting-red-team-review** — adversarial review of the whole result
- **science-superpowers:reporting-and-archiving-findings** — after all steps complete

**Subagents should use:**
- **science-superpowers:verifying-results-before-claiming** — before any subagent reports a step as done

**Alternative:**
- **science-superpowers:executing-analysis** — inline execution for harnesses without subagents
