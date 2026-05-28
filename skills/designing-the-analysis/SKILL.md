---
name: designing-the-analysis
description: Use when you have an approved research question and need a concrete analysis plan, before touching outcome data or fitting any model
---

# Designing the Analysis

## Overview

Write a comprehensive analysis plan assuming the analyst has zero context for this project and questionable statistical taste. Document everything they need: which datasets and variables, how each construct is computed, the exact model or test, the sample size / power justification, which confounds are handled and how, the decision rules, and the planned figures. Give them the whole thing as bite-sized steps. DRY. YAGNI. Pre-register. Validate pipelines on known data. Commit frequently.

Assume they are a capable programmer but know almost nothing about this domain, this dataset, or good statistical design.

**Announce at start:** "I'm using the designing-the-analysis skill to create the analysis plan."

**Save plans to:** `docs/science-superpowers/plans/YYYY-MM-DD-<topic>.md`

## Scope Check

If the question document still bundles several independent investigations, stop and split it — one plan per question. Each plan should produce an interpretable, self-contained result.

## Inputs You Need First

- The approved question document (`docs/science-superpowers/questions/...`)
- The prior-work survey: the adopted method, the confound list, and a prior effect size for powering

If you don't have a prior effect size, the design must include how you will justify the sample size anyway (smallest effect of interest, precision target, or a sensitivity analysis).

## Artifact & Data-Flow Structure

Before defining steps, map the pipeline. Data flows one direction: **raw → cleaned → derived → results**.

- List the scripts/notebooks you will create and what each is responsible for. One responsibility each.
- Name the data artifacts at each stage. Raw data is immutable; every transform writes a new artifact.
- Identify where the train/test or discovery/confirmation split happens (if any) and lock it before any modeling.
- Keep files focused. A 600-line "do everything" notebook is a design smell.

## Confound & Validity Plan

For each known confound from the survey, state how it is handled: measured and adjusted for, stratified, matched, design-excluded, or explicitly acknowledged as a limitation. "We'll see" is not a plan.

State the threats to validity you are accepting and why.

## Power / Sample Size

State the target effect size, alpha, desired power, and the resulting required N — or, for a fixed existing sample, the minimum detectable effect at the planned power. If underpowered, say so and decide with your human partner whether to proceed (e.g., reframe as estimation, not a hypothesis test).

## Bite-Sized Step Granularity

**Each step is one action (2-5 minutes).** Every step that touches data is paired with a *validation* — the science analog of watching a test fail then pass:

- "Write the data-loading code" — step
- "Run it; confirm row/column counts match the known dataset shape" — step
- "Write the cleaning transform" — step
- "Validate: assert no rows silently dropped, ranges within expected bounds" — step
- "Validate the pipeline on simulated data with a known ground-truth effect; confirm it recovers the effect" — step
- "Commit" — step

The simulated-data validation step is mandatory for any nontrivial estimator or model: if you never watched your pipeline recover a known signal, you don't know it works.

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Question] Analysis Plan

> **For agentic workers:** REQUIRED SUB-SKILL: pre-register this plan with science-superpowers:preregistering-analysis BEFORE execution. Then use science-superpowers:subagent-driven-analysis (recommended) or science-superpowers:executing-analysis to run it step-by-step. Steps use checkbox (`- [ ]`) syntax for tracking.

**Question:** [the falsifiable question, one sentence]

**Design:** [observational/experimental; cross-sectional/longitudinal; the comparison]

**Data:** [datasets, sample, unit of analysis]

**Primary analysis:** [the one model/test that answers the question]

**Decision rule:** [exactly what result confirms vs. disconfirms H1]

---
```

## Task Structure

````markdown
### Task N: [Analysis component]

**Artifacts:**
- Create: `analysis/exact_script.py`
- Reads: `data/raw/exact_file.csv` (immutable)
- Writes: `data/derived/exact_output.parquet`

- [ ] **Step 1: Write the loading/transform code**

```python
df = pd.read_csv("data/raw/exact_file.csv")
clean = df[df["value"].between(0, 100)]
```

- [ ] **Step 2: Validate the step**

Run: `python analysis/exact_script.py --check`
Expected: `rows in: 10342, rows out: 10298, dropped: 44 (out-of-range)` — dropped count matches the known data-quality issue, not silent loss.

- [ ] **Step 3: Run the primary model exactly as specified**

```python
model = smf.ols("outcome ~ exposure + age + site", data=clean).fit()
```

- [ ] **Step 4: Apply the pre-registered decision rule**

The estimate for `exposure` is interpreted against the rule fixed in the pre-registration — not re-decided here.

- [ ] **Step 5: Commit**

```bash
git add analysis/exact_script.py data/derived/exact_output.parquet
git commit -m "analysis: primary model for exposure effect"
```
````

## No Placeholders

Every step must contain the actual content the analyst needs. These are **plan failures** — never write them:

- "TBD", "choose an appropriate test", "handle outliers as needed", "tune the model"
- "Run statistics on the above" without naming the test and the variables
- "Adjust for confounders" without naming which and how
- "Similar to Task N" (repeat the specifics — steps may be read out of order)
- Any decision rule that depends on the result you haven't seen yet (that is HARKing; fix it in the design)

## Self-Review

After writing the plan, re-read the question document with fresh eyes and check the plan against it:

1. **Coverage:** Does a task answer the question? Does every hypothesis have an analysis?
2. **Researcher degrees of freedom:** Is every analytic choice (test, covariates, exclusions, transformations, cutoffs) specified in advance? List any that are still open and close them.
3. **Confound coverage:** Is every surveyed confound handled by a task?
4. **Placeholder scan:** Any of the failures above? Fix them.
5. **Consistency:** Do variable names, file paths, and the decision rule match across tasks?

Fix issues inline. If a question requirement has no task, add the task.

## Handoff

The plan is not ready to execute until its predictions and decision rules are locked.

**REQUIRED NEXT SKILL:** Use `science-superpowers:preregistering-analysis` to freeze the confirmatory hypotheses, predictions, and decision rules before any outcome is observed. Execution happens only after that.
