---
name: investigating-anomalous-results
description: Use when a result is surprising, impossible, contradicts a sanity check, a pipeline fails, a model won't converge, or a replication fails - before adjusting anything
---

# Investigating Anomalous Results

## Overview

Random tweaks waste time and manufacture false findings. Quietly dropping the inconvenient data point, nudging the cutoff, or re-running until it "works" doesn't fix the problem — it fabricates a result.

**Core principle:** ALWAYS find the root cause before adjusting anything. An adjustment made before you understand the cause is, at best, noise and, at worst, fraud.

**Violating the letter of this process is violating the spirit of it.**

The first question for any anomaly: **is this a code bug, a data issue, or a real finding?** You cannot answer by guessing, and you must not "fix" it until you know — because a real finding is not something to fix.

## The Iron Law

```
NO ADJUSTMENTS WITHOUT ROOT-CAUSE INVESTIGATION FIRST
```

No dropping data, changing a test, transforming a variable, re-running with new parameters, or "cleaning" until Phase 1 is complete. If you haven't found the cause, you cannot justify the adjustment.

## When to Use

- A result is surprising, too good, or contradicts what's known
- An impossible value (negative count, probability > 1, age of 500)
- A pipeline errors or a model won't converge
- A result contradicts a sanity check or a simple cross-tab
- A replication or robustness check disagrees with the primary result
- Performance that's suspiciously high (often leakage)

**Use this ESPECIALLY when:**
- The anomaly is *convenient* (it supports your hypothesis) — that's when the urge to skip investigation is strongest
- Under time pressure
- You've already tried one quick adjustment

## The Four Phases

Complete each before the next.

### Phase 1: Characterize the Anomaly

**Before any adjustment:**

1. **Read the output/error carefully.** The exact value, the exact message, the stack trace. Note shapes, counts, and where in the pipeline it appears.
2. **Reproduce it deterministically.** Fixed seed, same data version. Does it happen every time? If not reproducible, gather more data — don't guess.
3. **Check recent changes.** What changed in the code, the data version, or the environment since it last looked right? `git diff`, data provenance, package versions.
4. **Gather evidence at each pipeline stage.** Instrument raw → cleaned → derived → result. Print shapes, ranges, null counts, and key summaries at each boundary. This reveals *where* the anomaly enters.

```
raw:     N=10342, outcome mean=0.31, nulls=0
cleaned: N=10298, outcome mean=0.31, nulls=0      <- 44 dropped, expected
derived: N=10298, feature mean=4e7                <- WRONG: unit blew up here
result:  coefficient enormous                     <- symptom; cause is upstream
```

5. **Classify the cause** with the evidence: code bug, data issue, or real finding. Do not proceed assuming one without evidence.

### Phase 2: Pattern Analysis

1. **Find a working comparison.** A subset, variable, site, or time period that behaves as expected. What's different about the anomalous one?
2. **Compare against a reference.** A known correct result, a textbook expectation, a prior estimate from the survey. Read the reference method completely — don't skim.
3. **List every difference** between working and anomalous, however small. Don't assume "that can't matter."

### Phase 3: Hypothesis and Test

1. **Form a single hypothesis:** "The anomaly is caused by X because Y." Write it down. Be specific.
2. **Test minimally** on the smallest slice that exhibits it. One variable at a time.
3. **Verify before continuing.** Confirmed → Phase 4. Not confirmed → new hypothesis. Don't stack adjustments.
4. **When you don't know, say so.** "I don't understand why the derived feature inflates" — then investigate or ask. Don't pretend.

### Phase 4: Resolution

Resolve according to the cause you established:

- **Code bug:** Write a minimal failing check that reproduces it, fix the code at the source (not a downstream patch), re-run the affected steps, confirm the anomaly is gone and other results unchanged.
- **Data issue:** Handle it per a documented rule. If the rule was not pre-registered, the decision is a deviation — record it, and the affected analysis becomes exploratory. Dropping observations is legitimate ONLY when root cause shows they are invalid measurements (e.g., a sensor error), and that justification is documented. Never drop data because it's inconvenient.
- **Real finding:** It is a result, not a defect. Do NOT "fix" it. If it was not what you pre-registered, it is an exploratory finding — report it as such, and pre-register a fresh confirmatory test (ideally on new/held-out data) before claiming it.

**If 3+ adjustments fail:** STOP. The pipeline or the design may be wrong — repeated failures that each reveal a new problem indicate a structural issue, not a series of small bugs. Discuss the design with your human partner before another attempt. Re-opening the design or pre-registration must be documented as a deviation.

## Red Flags - STOP and Investigate

- "Let me just drop that outlier and re-run"
- "I'll nudge the threshold until it's significant"
- "Probably a fluke, let me re-run with a different seed" (changing the seed to change the result)
- "The result I want appeared, no need to dig into why the first run didn't"
- "Quick adjustment now, understand it later"
- Proposing an adjustment before tracing where the anomaly enters the pipeline
- **An adjustment that happens to make the result support your hypothesis**

**All of these mean: STOP. Return to Phase 1.**

## Your Human Partner's Signals You're Doing It Wrong

- "Is that even possible?" — you reported a value without sanity-checking it
- "Why did that point get dropped?" — you adjusted without documenting the cause
- "Did you check leakage?" — suspiciously good performance you didn't investigate
- "That seems too clean" — question the pipeline, not just the result

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "It's clearly an outlier, just remove it" | "Clearly" is a guess. Find why it's extreme; document if you remove it. |
| "Re-running with a new seed fixed it" | You changed the result by chance, not the cause. Investigate. |
| "The good result is the right one" | Convenient results need MORE scrutiny, not less. |
| "Emergency, no time to investigate" | Investigation is faster than retracting a wrong finding. |
| "Tweak the model, then understand it" | The first tweak sets a false trail. Understand first. |
| "Performance is just high, ship it" | Suspiciously high performance is usually leakage. Check. |

## Quick Reference

| Phase | Activities | Success Criteria |
|-------|-----------|------------------|
| 1. Characterize | Read, reproduce, check changes, instrument stages, classify | Know WHERE and WHICH (bug/data/finding) |
| 2. Pattern | Working comparison, reference, list differences | Identify the difference |
| 3. Hypothesis | Single theory, minimal test | Confirmed or new hypothesis |
| 4. Resolution | Fix bug / document data rule / report real finding | Anomaly explained, not just hidden |

## Related Skills

- **science-superpowers:verifying-results-before-claiming** — confirm the resolution actually holds
- **science-superpowers:preregistering-analysis** — a real but unregistered finding needs a fresh confirmatory pre-registration
- **science-superpowers:setting-up-reproducible-analysis** — deterministic reproduction depends on fixed seeds and pinned environments
