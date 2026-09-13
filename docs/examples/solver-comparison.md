# Worked example: comparing two solvers

[Documentation](../README.md) · [Getting started](../getting-started.md) · [Research workflow](../research-workflow.md)

This is an illustrative investigation, not a completed experiment. It shows the
decisions and artifacts to expect. No benchmark results or performance claims are
invented here.

## Start with a question that can be answered

Initial request:

> Is solver B better than solver A for our simulation pipeline?

Using `science-superpowers:framing-research-questions`, the agent clarifies what
“better” means. Runtime, peak memory, and solution accuracy are distinct targets.
Suppose your human partner chooses runtime at a fixed accuracy for a defined
problem family on one hardware configuration.

A possible framing is:

> On the reserved benchmark instances, does solver B reduce time to an independently
> verified solution by at least 20% relative to solver A under the same resource limits?

The problem instance is the unit of analysis. Repeated timings of the same instance
are technical repeats, not additional independent problems. The question document
records the family of instances, target hardware, accuracy measure, resource
limits, and exclusions. The 20% threshold is an illustrative engineering target
to agree before seeing benchmark outcomes.

## Ground and design the comparison

Use `science-superpowers:surveying-prior-work` to check solver assumptions,
accepted accuracy measures, benchmarking conventions, and known confounds. The
survey should cite the actual sources it consults; this example does not substitute
for that work.

The design then specifies:

- The reserved benchmark instances and their selection; separate cases for tuning
  and validating the pipeline.
- Solver versions, configurations, tolerances, and independently computed error
  or residual checks.
- Hardware, thread counts, warm-up procedure, run order, and number of timing repeats.
- The exact aggregation within each instance, primary comparison across instances,
  uncertainty method, and sample-size or precision justification.
- How failures, timeouts, and inaccurate solutions affect the comparison, so that
  unsuccessful runs cannot silently disappear from the denominator.

For example, the registered runtime metric could be the geometric mean of paired
B/A runtime ratios across eligible instances, with an interval computed by a
specified procedure at the instance level. The final plan must state the exact
procedure and eligibility rules, not leave them to the analyst after execution.

If the target configurations have never run, the agent offers
`science-superpowers:establishing-feasibility-first`. Your human partner can choose
measured probes and a bounded exploratory campaign. Results from that campaign
stay exploratory; a later confirmatory comparison uses unused instances or runs
chosen so they do not reuse the outcomes that shaped the hypothesis.

## Freeze the decision before running

The agent writes a new registration and uses the
[freeze helper](../preregistration.md). Suppose the agreed rule requires both
solvers to meet the accuracy and completion criteria, and the upper bound of the
specified interval for the runtime ratio to fall below `0.80`.

A ratio interval crossing `0.80` does not establish the target reduction. An
accuracy failure prevents the runtime claim under this rule. The registration
must distinguish an inconclusive result from evidence against the predicted
improvement; failure to meet the success rule does not prove equivalence.

Secondary memory measurements and any planned sensitivity analyses are listed
with their status. Unplanned analyses will be reported separately as exploratory.

## Execute and investigate surprises

The agent sets up the pinned environment, records provenance and seeds, validates
against independent known solutions, and runs the registered steps. It retains
an artifact for every instance, including failures.

Suppose a run appears unusually fast. The anomaly skill leads the agent to inspect
timers, completion status, and the independently computed solution error. If the
implementation accidentally omitted a registered accuracy check, fixing it
restores the planned method and requires rerunning and documenting the correction.
If the proposed response instead changes the accuracy threshold, that changes
the registered analysis and makes the affected result exploratory.

## Verify, review, and report

Before claiming a speedup, the agent reproduces the outputs, applies the frozen
rule, runs a correctly scoped audit, and requests critical review. A reviewer
checks whether comparisons use the same accuracy, failures were retained, and
repeated timings were mistaken for independent evidence.

The final report contains the measured ratio and interval, the decision under the
registered rule, completion and accuracy results, deviations, and limitations.
It limits the conclusion to the tested problem family, hardware, and settings.
Exploratory leads get their own section.

The archive includes the question, survey, plan, frozen registration, input
provenance, code, environment, per-instance outputs, reproduction commands, review
record, and audit output. Your human partner decides whether to share the report,
continue the investigation, or keep the work as it stands.
