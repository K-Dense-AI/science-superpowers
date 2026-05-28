# Statistical Fallacies Reference

The traps pre-registration and reproducible analysis are designed to prevent. Each entry: what it is, how it sneaks in, and the fix.

## p-hacking (data dredging)

**What:** Trying many analyses and reporting the ones that cross significance.

**How it sneaks in:** "Let me try with and without that outlier / log-transformed / split by gender / with these three covariates." Each choice is a fork; twenty forks make a false positive near-certain.

**Fix:** Pre-specify the one primary analysis. Run it. Label every other cut exploratory. Report how many tests were run.

## HARKing (Hypothesizing After Results are Known)

**What:** Presenting a hypothesis discovered in the data as if it were predicted in advance.

**How it sneaks in:** You see a striking subgroup effect, then write the introduction as though you expected it. The story is clean because the data wrote it.

**Fix:** Predictions only count if frozen before the result. A hypothesis the data generated must be tested on new data.

## The garden of forking paths

**What:** Even with a single analysis "decided" per dataset, the *flexibility* to have chosen differently for different data inflates false positives. You didn't try 20 analyses — but you would have picked a different one had the data looked different.

**How it sneaks in:** Reasonable-seeming, data-contingent choices made in good faith ("for this data, excluding non-responders is clearly right").

**Fix:** Make the choices data-independent and explicit before seeing outcomes. If a choice genuinely depends on data, decide it on a held-out split.

## Optional stopping

**What:** Peeking at the data as it accumulates and stopping when significant.

**How it sneaks in:** "It's already p < .05 with the data we have, no need to collect more." Sequential peeking can push the true false-positive rate far above the nominal alpha.

**Fix:** Fix N in advance, or use a proper sequential design (group sequential, alpha spending) with corrections specified up front.

## Multiple comparisons

**What:** Running many tests and interpreting uncorrected p-values.

**How it sneaks in:** Twenty outcomes, twenty tests, one "significant" — reported as the finding.

**Fix:** Pre-specify the primary outcome. Correct for multiplicity (Bonferroni, Holm, FDR) per the registration. Treat the rest as exploratory.

## Data leakage

**What:** Information from the target or the test set contaminates training/feature construction, inflating apparent performance.

**How it sneaks in:** Scaling/imputing/feature-selecting on the full dataset before the train/test split; using future information to predict the past; an ID or proxy that encodes the label.

**Fix:** Split first, then fit all preprocessing on the training fold only and apply to test. Audit features for target proxies. Respect time ordering.

## Overfitting

**What:** A model captures noise specific to the sample and fails to generalize.

**How it sneaks in:** Tuning hyperparameters on the test set; reporting in-sample fit as if it were predictive performance; too many parameters for the data.

**Fix:** Hold out a final test set used once. Use cross-validation for tuning. Report out-of-sample performance. Prefer the simplest model that fits.

## p-value misinterpretation

**What:** Treating p as the probability the null is true, or 1 − p as the probability the effect is real; treating p > .05 as "no effect."

**How it sneaks in:** "p = .04 so there's a 96% chance the effect is real" (false). "p = .20 so there's no effect" (absence of evidence ≠ evidence of absence).

**Fix:** p is P(data this extreme | null true). Report effect sizes and confidence/credible intervals, not just p. A non-significant result with a wide interval is inconclusive, not null.

## Underpowered studies

**What:** Too little data to detect a plausible effect.

**How it sneaks in:** Running the test "to see," ignoring power. Underpowered studies miss real effects and, when they do hit significance, overestimate the magnitude (winner's curse / Type M error).

**Fix:** Justify N with a power analysis using a prior effect size. If fixed and underpowered, reframe as estimation with intervals, and say so.

## Simpson's paradox / confounding

**What:** An aggregate association reverses or vanishes within subgroups because of a lurking variable.

**How it sneaks in:** Pooling across a confounder (e.g., site, era, severity) that is associated with both exposure and outcome.

**Fix:** Identify confounders during prior-work survey; adjust, stratify, or match per the design. Inspect within-group patterns, not just the pooled one.

## Base-rate neglect

**What:** Ignoring prior probability when interpreting a positive result.

**How it sneaks in:** A "significant" screen for a rare condition is mostly false positives if the base rate is low, even at high specificity.

**Fix:** Reason with base rates and predictive values, not just sensitivity/specificity or p-values.

## Survivorship & selection bias

**What:** Analyzing only the units that "survived" some selection, distorting the picture.

**How it sneaks in:** Dropping incomplete cases that differ systematically; studying only current customers/patients; conditioning on a collider.

**Fix:** Map how units enter the sample. Check whether exclusions relate to the outcome. Avoid conditioning on variables caused by both exposure and outcome.

## Regression to the mean

**What:** Extreme measurements tend to be less extreme on remeasurement, mimicking an effect.

**How it sneaks in:** Selecting the worst performers, intervening, and crediting improvement to the intervention.

**Fix:** Use a control group. Pre-register the comparison. Don't select on the baseline extreme without accounting for it.

## The fix that ties them together

Pre-register the primary analysis and decision rule, fix the sample, split before you preprocess, correct for multiplicity, label everything unregistered as exploratory, and report effect sizes with intervals. The fallacies above are exactly the degrees of freedom that pre-registration removes.
