# Getting started

[Documentation](README.md) · [Installation](installation.md) · [Research workflow](research-workflow.md)

Start in the repository where your research code and study artifacts will live.
Install Science Superpowers for your harness, open a fresh session, and give the
agent a question with enough context to frame it.

## Your first prompt

```text
I want to compare two solvers for our simulation pipeline. We care about runtime
at a fixed accuracy on a defined family of problems. The production benchmarks
have not been run. We have separate validation cases with known solutions.

Use Science Superpowers to help frame the question before inspecting benchmark
outcomes. We have a two-hour compute budget. Ask me about any missing design
constraints, then propose the investigation.
```

Useful context includes the population or problem family, the decision the answer
will inform, available data and its provenance, outcomes already examined, known
limitations, and compute or time constraints. Say explicitly if you have already
explored the data: that determines which future tests can be confirmatory.

You normally do not need to memorize skill names. The bootstrap directs the agent
to load relevant skills. To request one explicitly, write, for example:

```text
Use science-superpowers:framing-research-questions to frame this investigation.
```

This is a natural-language request; slash-command syntax varies by harness.

## What should happen first

The agent should announce the framing skill, clarify the question, propose precise
framings, and ask your human partner to review the framing. It should write the
approved question to `docs/science-superpowers/questions/YYYY-MM-DD-<topic>.md` and
have the written version reviewed before moving to the survey and design.

Existing schemas, data dictionaries, and provenance help establish context.
Loading, profiling, plotting, or modeling outcomes comes after the relevant
gates. An immediate outcome plot is a reason to check the
[bootstrap](troubleshooting.md#the-agent-starts-analyzing-before-framing).

If nobody knows whether the computation can run, the agent may offer
[feasibility mode](research-workflow.md#feasibility-mode). Your human partner must
explicitly choose it. Otherwise, the standard workflow applies.

## Before the first confirmatory run

Expect an approved question, a cited prior-work synthesis, and an analysis plan
with exact inputs, methods, exclusions, and decision rules. The agent should
validate the pipeline on separate known-answer cases, freeze the pre-registration,
and prepare a reproducible environment before running the confirmatory analysis.

Use the [pre-registration walkthrough](preregistration.md) to understand the
mechanical freeze. It is a small Git exercise and needs no research dataset.

## What you should receive

A completed investigation should include:

- A report separating confirmatory results from exploratory leads, with uncertainty,
  limitations, and every deviation recorded.
- Code, immutable-input provenance and checksums, an environment lockfile, runtime
  versions, seeds, and exact reproduction commands.
- The frozen pre-registration and audit output, with warnings examined.
- Freshly reproduced evidence for reported numbers and a record of critical review.

Publishing or discarding work is a separate decision for your human partner.
Follow the [solver comparison example](examples/solver-comparison.md) for a full
walkthrough of the decisions behind these artifacts.
