---
name: surveying-prior-work
description: Use after framing a question and before designing an analysis, or when choosing a method, judging whether a result is novel, or needing a prior effect size for a power calculation
---

# Surveying Prior Work

## Overview

Before designing an analysis, ground the question and your chosen methods in what is already known. Most questions have established methods, known confounds, and prior effect sizes. Reinventing a method badly — or rediscovering a known artifact and reporting it as a finding — wastes effort and erodes credibility.

**Core principle:** Find out what is already known before you generate new claims.

This is the science analog of reading the existing codebase before writing new code. It is a flexible skill — adapt depth to the stakes of the investigation.

## When to Use

- After `framing-research-questions`, before `designing-the-analysis`
- When selecting a statistical method or model and unsure what is standard
- When a result looks novel — check whether it is a known effect or artifact first
- When you need a plausible prior effect size to power the study
- When you suspect confounds but don't know which are established in the field

## What to Ground

Survey four things:

1. **Established methods** — what is the standard, accepted way to analyze this kind of question? What are its assumptions and failure modes?
2. **Known confounds and artifacts** — what variables are known to drive this outcome? What measurement artifacts are common in this data type?
3. **Prior effect sizes** — what magnitude have others found? This feeds the power/sample-size calculation in the analysis design.
4. **Relationship to prior work** — is this a replication, an extension, a new population, or genuinely novel? Be honest about which.

## The Process

1. **List what needs grounding** — turn the "open questions for prior-work survey" from the question document into concrete search targets.
2. **Search** — use web search and any available literature tools for published methods and effect sizes; search the repo and your human partner's prior analyses for in-house precedent and conventions.
3. **For broad surveys, dispatch parallel subagents** — one per independent sub-topic (a method, a confound, a prior estimate). REQUIRED: use `science-superpowers:dispatching-parallel-investigations` for the workflow. This keeps your own context clean.
4. **Synthesize** — write a short prior-work note (or a section appended to the question document):
   - Established method(s) you will adopt and why
   - Confounds you must measure or control for
   - Prior effect size(s) and the source, for powering the design
   - Honest statement of how this investigation relates to prior work
5. **Cite sources** — record where each fact came from so the design and final report can reference it. When you present findings from web search, follow your platform's citation standards.

## Red Flags

- Reaching for a method you invented when a standard one exists → find and use the standard one (or justify the deviation explicitly)
- Designing the analysis with no idea what effect size to expect → you skipped the power input; survey first
- About to report something as novel without having checked → search first; novelty is a claim that needs evidence
- Ignoring a confound because checking is inconvenient → known confounds are not optional

## Handoff

After grounding, invoke `science-superpowers:designing-the-analysis`. Bring forward the adopted methods, the confound list, and the prior effect size for powering the design.
