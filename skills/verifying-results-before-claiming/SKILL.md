---
name: verifying-results-before-claiming
description: Use when about to claim a result, effect, significance, or that an analysis reproduces, before reporting or writing it up - requires running the analysis fresh and reading the actual output first; evidence before claims always
---

# Verifying Results Before Claiming

## Overview

Claiming a finding without fresh verification is dishonesty, not efficiency.

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO CLAIMS WITHOUT FRESH REPRODUCED EVIDENCE
```

If you haven't run the analysis in this state and read its actual output, you cannot claim its result. "It was significant earlier" is not evidence now.

## The Gate Function

```
BEFORE claiming any result or expressing satisfaction:

1. IDENTIFY: What command/analysis proves this claim?
2. RUN: Execute it fresh and complete (from the immutable raw data, fixed seed)
3. READ: The actual output — the estimate, the interval, the p-value, the diagnostics
4. CHECK: Do the method's assumptions hold? Does it reproduce?
5. VERIFY: Does the output actually support the claim?
   - If NO: state the real result with evidence
   - If YES: state the claim WITH the evidence (number + interval)
6. ONLY THEN: make the claim

Skip any step = asserting, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| "The effect is significant" | Fresh run; read estimate, CI, and p | "It was significant before" |
| "There's no effect" | Effect size + interval showing precision | A non-significant p (could be underpowered) |
| "The result reproduces" | Re-run from raw data + fixed seed → same number | "It ran fine earlier" |
| "Assumptions are met" | The diagnostic output, read | "It's probably fine" |
| "The model is good" | Out-of-sample metric | In-sample fit / training accuracy |
| "Data cleaned correctly" | Validation counts (rows in/out, ranges) | "The script ran without error" |
| "Confirmatory finding" | It was pre-registered AND re-run as registered | Matches what I expected |
| "The subagent finished" | Inspect the committed artifacts/diff | The subagent said "done" |

## Red Flags - STOP

- Using "should", "probably", "seems to", "looks significant"
- Expressing satisfaction before verification ("Great, it worked!", "Perfect!", "Confirmed!")
- About to write up / report / commit a conclusion without a fresh run
- Reporting a p-value you computed before the latest code change
- Calling a result "reproducible" without having re-run it from raw
- Trusting a subagent's success report
- Describing a non-significant result as "no effect" without checking power/interval
- **ANY wording implying a finding without having just produced the evidence**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "It was significant last run" | Re-run it now. Code/data may have changed. |
| "I'm confident in the result" | Confidence is not evidence. |
| "The script ran without errors" | Running ≠ correct. Read the output. |
| "p < .05, so it's real" | p is not the probability the effect is real. Report effect + interval. |
| "p > .05, so no effect" | Could be underpowered. Absence of evidence ≠ evidence of absence. |
| "The subagent reported success" | Verify the artifacts independently. |
| "It reproduces, I'm sure" | Re-run from raw + seed and show the same number. |
| "Different words, so the rule doesn't apply" | Spirit over letter. |

## Key Patterns

**Significance / effect:**
```
✅ [Re-run the model] [Read: beta=0.23, 95% CI [0.08, 0.38], p=.002] "Exposure raises the outcome; CI excludes zero."
❌ "The effect looked significant."
```

**Reproducibility:**
```
✅ Fresh env → re-run from data/raw with seed → same estimate to reported precision → "Reproduces."
❌ "It ran earlier, so it reproduces."
```

**Null result:**
```
✅ [Read: beta=0.01, 95% CI [-0.12, 0.14]] "No detectable effect; the interval rules out effects larger than ~0.14."
❌ "p=0.3, so there's no effect."
```

**Model performance:**
```
✅ [Held-out test set, used once] [AUC=0.78] "Out-of-sample AUC 0.78."
❌ "Training accuracy is 0.97, the model is great."
```

**Subagent delegation:**
```
✅ Subagent reports done → inspect committed code + output artifact → confirm → report actual state
❌ Trust the report
```

## When To Apply

**ALWAYS before:**
- Any statement of a result, effect, or significance
- Any claim that an analysis reproduces or that assumptions hold
- Any expression of satisfaction about a finding
- Writing up, reporting, committing a conclusion, or requesting review
- Trusting a subagent's output

**Applies to:** exact phrases, paraphrases, synonyms, and any implication of a verified finding.

## The Bottom Line

Run it fresh. Read the output. Check it reproduces. THEN state the result — with the number and the interval.

This is non-negotiable.

## Related Skills

- **science-superpowers:investigating-anomalous-results** — if verification reveals the result doesn't hold
- **science-superpowers:requesting-red-team-review** — independent scrutiny after you've verified
