---
name: establishing-feasibility-first
description: Use when your human partner has explicitly opted into exploratory or feasibility mode - a compute-heavy simulation, an unproven pipeline, an unbenchmarked solver, an untested cluster job - or when whether the work can run at all is still unknown, when a plan's largest configuration has never been executed, when a memory or wall-clock ceiling is estimated rather than measured, or when someone proposes pre-registering over runs that have never happened
---

# Establishing Feasibility First

## Overview

When it is not yet known whether the computation can run at all, the decisive experiment is not scientific — it is whether the thing executes at scale. Run that experiment first, on the smallest honest version of the real path, and let its measured answer shape everything downstream.

**Core principle:** Process built on an unmeasured feasibility number is process built on a guess. When the guess is wrong, every plan, prediction, and decision rule resting on it was written for a study that does not exist.

This is the deliberate exception to the standard sequence. It exists because the standard sequence assumes the analysis *can* be run, and pays its full cost before testing that assumption.

## The Iron Laws

```
NOTHING IS FEASIBLE UNTIL IT HAS RUN
NOTHING IS BOUNDED UNTIL THE BOUND HAS FIRED
```

An estimate is not a measurement. A declared kill criterion is not a kill criterion. Both must be demonstrated by execution before any work is built on top of them.

## The Entry Gate — Opt-In Only

**Only your human partner can enter this mode.** You may *offer* it; you may never declare it yourself.

Offer it when you notice the triggers: an unrun pipeline, an unbenchmarked solver, an estimated rather than measured ceiling, or a plan whose largest configuration has never executed. Make the offer concrete and wait:

> "Whether this can run at scale is still unknown, and everything downstream depends on the answer. I can enter feasibility mode: a minimal end-to-end runner, three scaling probes, then one exploratory campaign — deferring the survey, the analysis plan, and pre-registration until we know what is runnable. That defers confirmatory claims; nothing produced in this mode can support one. Do you want that, or the standard confirmatory sequence?"

**If they decline, or do not answer, you are in the standard sequence.** Silence is not opt-in. Use `science-superpowers:framing-research-questions` and proceed normally.

**You may not enter this mode to escape rigor.** "This feels exploratory" is not opt-in. "The pre-registration is getting tedious" is not opt-in. Only an explicit choice by your human partner opens this path.

## Before Anything: A Short Framing

Feasibility mode defers the survey and the analysis plan. It does **not** skip framing — it shrinks it.

Write a few sentences, not a document, and get agreement:

- **The feasibility question** — the specific thing that must be true for the science to be possible, stated as a measurable threshold ("a 30M-row assembly fits in under 60% of RAM and solves in under 8 hours")
- **The scientific question it gates** — one sentence, held for later
- **The abandonment condition** — what measured result means this approach is not viable, decided now

Keep these separate. Tangling them is what produces pre-registrations written over runs that cannot happen.

Get explicit agreement on the abandonment condition specifically — not an inference from "go ahead". It is necessarily a judgement call made before any measurement exists, so it is both the item most likely to be wrong and the one that later fires and stops the work. Revise it freely before the probes run; never after a probe has reported.

## Phase 1: The Minimal End-to-End Runner

Build the thinnest thing that exercises the **real** code path end to end, at a trivial problem size.

- Real solver, real assembly, real I/O — a stub anywhere means the phase proved nothing about the real path
- Smallest size that still touches every stage
- One ground-truth check: a case whose answer is known analytically, asserted to tolerance

**If the thing under test does not exist yet, build only the adapter to it.** Do not build the study around a component that has never been called. Where the real component is genuinely unavailable, a reference implementation is acceptable — but label every number it produces as surrogate, and never let a surrogate result gate a decision without saying so.

**Beware the degenerate test case.** A manufactured problem whose solution is an eigenvector of the operator converges in a fixed number of iterations regardless of size, and will report flat, beautiful, meaningless scaling. If every probe converges in the same handful of iterations, suspect the test problem before believing the result.

**A clean number is not a correct number.** Convergence, a plausible order, and a tidy extrapolation are all available to a quantity measured at the wrong location, in the wrong component, or under a broken preconditioner — and they look exactly like success. Check the measured quantity against an independent reference (an analytic solution, a published value, a different implementation) before you believe it, and treat a large disagreement as an anomaly to root-cause rather than a calibration offset to absorb.

Phase 1 is done when the real path has run end to end once and produced a correct known answer.

## Phase 2: Three Scaling Probes

Three measured points, then at most one inference hop.

**First, write the feasibility budget** to `docs/science-superpowers/feasibility/YYYY-MM-DD-<topic>.md` — before any probe runs:

```markdown
# Feasibility: <topic>

**Feasibility question:** <the measurable threshold>
**Scientific question it gates:** <one sentence, deferred>

## Budget
| Resource | Per-run limit | Whole-sweep limit | On breach |
|----------|---------------|-------------------|-----------|
| Wall clock | <...> | <...> | record status=timeout, stop |
| Peak memory | <...> | — | record status=oom, stop |
| Iterations | <...> | — | record achieved residual, stop |

## Kill criteria
- <exact condition> -> <exact action>
- Consecutive failures before abandoning the ladder: <N>

## Not a stop criterion
- Sunk cost. Time already spent is not an input to any rule above.
- "We're close." Position in the case list is not fraction of work done.

## Abandonment condition
- <measured result that means this approach is not viable>

## Kill-criteria verification
- <criterion> -> fired deliberately at <when>, observed <what>
```

**The budget is your partner's, not yours.** Declaring an amendment in advance is necessary but not sufficient: granting yourself more compute because the sweep ran out is the one move that turns a budget into a formality. Refining *how* a limit is enforced is yours to fix. Enlarging the total envelope is your partner's call — ask, in one line, and record the answer.

**Then prove every kill criterion fires.** Construct a case that breaches each limit and confirm the limit produces a *record*, not a hang, not a crash, and not a silent success. This costs about a minute and is not optional.

Untested limits fail in ways that are invisible until they matter: a memory rlimit that is a no-op on the host OS, a `timeout` binary that does not exist on the platform so the job never starts, a killed run that records success with a residual computed from a zeroed solution vector. Each of those looks exactly like a working budget right up until it is load-bearing.

**Then run three probes** — three *measured* points, geometrically spaced, positioned as high as the budget allows. Cheap calibration runs to find where the ladder should sit do not count against the three; they are how you position it. If the work has several implementation paths (assembled vs matrix-free, direct vs iterative), each path that could decide feasibility gets its own three, because their ceilings differ by orders of magnitude.

- Fit on the **largest** rungs. Small rungs are pre-asymptotic and will bend the exponent; a fit that moves substantially when small points are dropped is not a fit.
- Recompute the convergence residual explicitly. Do not trust a solver's own success code — a stopping rule of the form `||r|| <= btol*||b|| + atol*||A||*||x||` reports success at a residual floor that *rises* with problem size, so "converged" can mean an error two orders of magnitude off target.
- Record the **extrapolation factor**: target size divided by largest measured size. Beyond about 10×, you do not have a feasibility answer, you have a hope. Push the ladder higher or say so plainly.
- Persist an artifact per probe. A case with no artifact is not a completed case, whatever the log says.

**If a probe says infeasible, test the obvious mitigation before accepting it.** The most expensive mistake available here is to accept a ceiling derived from one implementation path and build a study around it. If you can name a mitigation — a matrix-free operator, a different factorization, chunking, a preconditioner — measure it *now*, in this phase. Do not write it into a recommendations section and continue as if the ceiling were real. A ceiling that has not survived its own obvious mitigation is not a ceiling.

**When a mitigation works, re-measure where the ceiling went.** It usually moves rather than vanishes: relieve the assembler and the limit reappears in a boundary-condition matrix copy, relieve that and it reappears in the solve. Read the artifact to find which stage actually died — a run that recorded `nnz` before dying was killed *after* assembly, and attributing that ceiling to the assembler would send you optimizing the wrong stage.

**A failing mitigation may be a broken test rather than a real limit.** Before reporting that an approach does not work, confirm you invoked it correctly — a preconditioner that violates the solver's symmetry requirement produces divergence that looks like an unsuitable method. Reporting a bug in your test as a property of the pipeline is how a viable path gets abandoned.

## Phase 3: One Exploratory Campaign

One campaign. Its purpose is to find out what the system does, not to establish anything.

- Run it inside the budget, with the verified kill criteria armed
- **Span enough range to distinguish alternatives.** A campaign's value is set by the width of the range it sweeps, not the number of configurations in it: many points packed into one decade cannot separate a power law from a gently curved alternative, while a handful spread over three decades can. Before running, ask what competing explanation this campaign could rule out — if the answer is none, widen the range rather than adding configurations
- Keep provenance: environment, seeds, code version, per-case artifacts
- Report everything under an **Exploratory** heading
- Anomalies still get root-caused — use `science-superpowers:investigating-anomalous-results`. Feasibility mode relaxes sequencing, never honesty

**Nothing from this campaign is confirmatory. Ever.** Not the striking effect, not the clean scaling law, not the result that matches the hypothesis. These are leads for a pre-registration that has not been written yet.

Resist growing the campaign. "One more configuration" is how one campaign becomes the study you were supposed to pre-register.

## Phase 4: The Exit Gate — Your Human Partner Decides

Feasibility mode does not graduate itself. When the campaign completes, report and stop:

> "Feasibility settled: <measured result, with the extrapolation factor>. Exploratory campaign found <leads, labeled>. Nothing here is confirmatory. Options: (a) pre-register a confirmatory study now that we know what is runnable, (b) another exploratory campaign, (c) abandon this approach — the abandonment condition <did/did not> trigger. Which?"

**Only your human partner chooses.** Do not begin surveying, designing, or pre-registering on your own initiative because the campaign looked promising. The transition out of this mode is theirs, exactly as the transition in was.

**On exit to confirmatory work**, the standard sequence resumes at full strength: `science-superpowers:surveying-prior-work`, then `science-superpowers:designing-the-analysis`, then `science-superpowers:preregistering-analysis`. The feasibility measurements are legitimate inputs to that design — that is what they were for. The exploratory *results* are not evidence; they are hypotheses. Say so in the pre-registration: record that the design was informed by exploratory work, and which parts.

## What Stays On, What Defers

| Discipline | In feasibility mode |
|---|---|
| Honest labeling of exploratory vs confirmatory | **On** — the whole mode is labeled exploratory |
| Root-causing anomalies | **On** — never tune past a surprising number |
| Pinned environment, recorded seeds, provenance | **On** — an unreproducible probe is not a measurement |
| Verifying a claim before making it | **On** |
| Short framing of the feasibility question | **On** — a few sentences |
| Prior-work survey | Deferred to exit |
| Detailed analysis plan | Deferred to exit |
| Pre-registration and freezing | Deferred to exit — **deferred, not cancelled** |
| Red-team review, archival reporting | Deferred to exit |
| Confirmatory claims of any kind | **Forbidden until exit** |

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "This feels exploratory, so I'm in feasibility mode" | Only your human partner opts in. Feeling exploratory is not opt-in. |
| "The extrapolation is solid, no need to run it" | An estimate that gates work must be measured. Ceilings are wrong by factors of 50. |
| "I'll write the plan while the probes run" | A plan written against an unmeasured ceiling is rework. Wait for the number. |
| "The budget is written, the limits are set" | Written is not fired. Prove each one kills something. |
| "The solver reported convergence" | Solver success codes encode their own stopping rule, not yours. Recompute the residual. |
| "It's infeasible, so let's redesign around that" | Test the mitigation you just named. Then it is a ceiling. |
| "The mitigation worked, that ceiling is gone" | Ceilings move rather than vanish. Re-measure which stage dies now. |
| "That approach diverged, it's unsuitable" | Confirm you invoked it correctly first. A broken test is not a property of the method. |
| "The sweep needs a bit more compute, I'll amend the budget" | Enforcement fixes are yours; a larger envelope is your partner's call. Ask. |
| "It converged cleanly with a sensible order, so it's right" | Wrong quantities converge tidily too. Check against an independent reference. |
| "More configurations will make the campaign conclusive" | Range separates hypotheses; count does not. Widen instead. |
| "This exploratory result is too clean to waste" | It is a lead. Pre-register it and test it on runs you have not used. |
| "We're 14 of 20 cases in, let's finish" | Position in a list is not fraction of work. The remaining cases may be most of the compute. |
| "One more configuration in the campaign" | That is the study. Exit the mode and pre-register it. |
| "The campaign went well, I'll start the survey" | The exit gate is your partner's. Report and stop. |

## Red Flags — STOP

- About to write a plan, criterion, or prediction for a configuration that has never run
- A number that gates downstream work came from extrapolation, not execution
- A kill criterion exists in a document but has never been observed firing
- A named mitigation sits in a recommendations section, untested, while work proceeds around it
- Every probe converges in suspiciously few iterations
- A clean, converged, plausibly-ordered number that has never been checked against an independent reference
- Granting yourself additional compute after the declared budget is exhausted
- Attributing a ceiling to a stage without reading the artifact to see which stage actually died
- Cases marked complete with no persisted artifact
- Extrapolating more than ~10× beyond the largest measured point
- Reaching for the words "confirmatory", "significant", or "we found" before the exit gate
- Entering or leaving this mode without your human partner saying so

## The Bottom Line

```
Can it run?     -> measure it, at the top of the ladder, before building on the answer
Is it bounded?  -> fire the bound and watch it catch
Is it a finding? -> not in this mode. It is a lead.
```

## Handoff

**Staying in feasibility mode:** `science-superpowers:investigating-anomalous-results` for surprising probe results; `science-superpowers:setting-up-reproducible-analysis` if the workspace is not yet pinned and seeded.

**On exit, only when your human partner says so:** `science-superpowers:surveying-prior-work` -> `science-superpowers:designing-the-analysis` -> `science-superpowers:preregistering-analysis`.
