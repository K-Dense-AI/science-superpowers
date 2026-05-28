---
name: receiving-critical-review
description: Use when receiving critical feedback on an analysis or manuscript, before implementing suggestions, especially if feedback seems unclear or methodologically questionable - requires verification, not performative agreement or blind changes
---

# Receiving Critical Review

## Overview

Critique of an analysis requires technical evaluation, not emotional performance.

**Core principle:** Verify before changing. Ask before assuming. Methodological correctness over social comfort.

A reviewer pointing at a confound is doing you a favor only if you check whether the confound is real. Reflexively agreeing — or reflexively defending — both skip the verification that makes review worthwhile.

## The Response Pattern

```
WHEN receiving review feedback:

1. READ: The complete feedback without reacting
2. UNDERSTAND: Restate the methodological concern in your own words (or ask)
3. VERIFY: Check it against the data, code, and pre-registration
4. EVALUATE: Is it correct FOR THIS analysis?
5. RESPOND: Technical acknowledgment or reasoned pushback
6. ACT: One item at a time, re-running and re-verifying each
```

## Forbidden Responses

**NEVER:**
- "You're absolutely right!" (before you've checked)
- "Great catch!" / "Excellent point!" (performative)
- "Let me fix that now" (before verification)

**INSTEAD:**
- Restate the methodological concern
- Ask a clarifying question
- Push back with reasoning if it's wrong for this analysis
- Or just verify and report what you found

## Handling Unclear Feedback

```
IF any item is unclear:
  STOP - do not change anything yet
  ASK for clarification

WHY: Methodological items interact. Adjusting for the wrong confound
because you misread the concern can bias the result further.
```

## Source-Specific Handling

### From your human partner
- Trusted — verify, then act
- Still ask if scope is unclear
- No performative agreement; skip to verification or a technical acknowledgment

### From an external or red-team reviewer
```
BEFORE changing anything:
  1. Is it methodologically correct for THIS data and design?
  2. Would the change itself introduce bias (e.g., adding a collider as a covariate)?
  3. Is there a pre-registered reason the analysis is the way it is?
  4. Does the reviewer have the full context (the pre-registration, the data structure)?

IF the suggestion seems wrong:
  Push back with technical reasoning and evidence

IF you can't verify:
  Say so: "I can't verify this without [X]. Should I [investigate/ask]?"

IF it conflicts with the pre-registration:
  A change to the registered analysis is a deviation. It renders that
  analysis exploratory. Flag this explicitly before making the change.
```

## The Pre-Registration Guard

A reviewer may suggest a "better" analysis. Before adopting it:
- If it changes the pre-registered confirmatory analysis, you are moving from confirmatory to exploratory. That may be the right call — but say so, and report it accordingly.
- Don't let good-faith "improve it" feedback silently convert a confirmatory result into a post-hoc one.

## When To Push Back

- The suggestion would introduce bias (conditioning on a collider, adjusting away a mediator you care about, leakage)
- It treats observational data as if it supported causal claims, or vice versa
- The reviewer lacks context the pre-registration provides
- It contradicts your human partner's design decisions (raise with them)

**How:** technical reasoning, not defensiveness. Show the diagnostic, the DAG, the pre-registration line, or the reproduced number.

## Acknowledging Correct Feedback

When feedback IS correct:
```
✅ "Verified — site does confound this. Added it; estimate drops to 0.09 [−0.01, 0.19]. Now inconclusive."
✅ "Confirmed leakage: the scaler was fit before the split. Refit on train only; AUC falls to 0.71."
✅ [Just fix it, re-run, and show the new number]

❌ "You're absolutely right!"
❌ "Great catch!"
❌ "Thanks for spotting that!"
❌ ANY gratitude or praise performance
```

**Why no thanks:** the corrected, re-verified result shows you heard the feedback. State the fix and the new evidence.

## Gracefully Correcting Your Pushback

If you pushed back and were wrong:
```
✅ "You were right — I checked and the assumption is violated. Re-running with the robust estimator."
❌ Long apology or defense of why you pushed back
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Performative agreement | State the concern or verify |
| Blind change | Check against data/code/prereg first |
| Batch edits without re-running | One at a time, re-verify each |
| Assuming the reviewer is right | Check whether the change biases the result |
| Silently changing the registered analysis | Flag it as a deviation → exploratory |
| Avoiding pushback | Methodological correctness > comfort |

## The Bottom Line

External feedback = hypotheses to verify, not orders to follow.

Verify against the data and the pre-registration. Question. Then act — and re-verify with `science-superpowers:verifying-results-before-claiming`.
