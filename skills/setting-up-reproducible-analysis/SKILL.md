---
name: setting-up-reproducible-analysis
description: Use when starting analysis work that needs isolation, or before executing a pre-registered plan - ensures an isolated, reproducible workspace with pinned environment, fixed seeds, and immutable raw data
---

# Setting Up a Reproducible Analysis

## Overview

Ensure the analysis happens in an isolated workspace that another person (or future you) can reproduce exactly: same code, same environment, same seed, same immutable input data.

**Core principle:** A result you cannot reproduce is not a result. Set up reproducibility before you run anything.

**Announce at start:** "I'm using the setting-up-reproducible-analysis skill to set up an isolated, reproducible workspace."

## Step 0: Detect Existing Isolation

Before creating anything, check whether you're already in an isolated workspace.

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

**Submodule guard:** `GIT_DIR != GIT_COMMON` is also true in submodules. Verify you're not in one:

```bash
git rev-parse --show-superproject-working-tree 2>/dev/null
```

**If `GIT_DIR != GIT_COMMON` (and not a submodule):** already in a linked worktree. Skip to Step 2 (Environment). Don't create another.

**If `GIT_DIR == GIT_COMMON`:** normal checkout. If your human partner hasn't already stated a preference, ask before creating a worktree:

> "Would you like me to set up an isolated worktree? It keeps this analysis separate from your current branch."

Honor any declared preference. If declined, work in place and continue to Step 2.

## Step 1: Create Isolated Workspace

**Native tools first.** If you have a native worktree tool (`EnterWorktree`, `WorktreeCreate`, a `/worktree` command, a `--worktree` flag), use it and skip to Step 2. Using `git worktree add` when a native tool exists creates phantom state the harness can't manage.

**Git fallback** (only if no native tool):

```bash
# Prefer an existing .worktrees/ (must be git-ignored), else default to it
git check-ignore -q .worktrees 2>/dev/null || echo ".worktrees/" >> .gitignore
git worktree add ".worktrees/$BRANCH_NAME" -b "$BRANCH_NAME"
cd ".worktrees/$BRANCH_NAME"
```

If `git worktree add` fails with a sandbox permission error, tell your human partner and work in the current directory instead.

## Step 2: Pin the Environment

A reproducible result needs a pinned environment. Detect and set one up:

```bash
# Python
if [ -f environment.yml ]; then conda env create -f environment.yml || conda env update -f environment.yml; fi
if [ -f requirements.txt ]; then python -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then python -m venv .venv && . .venv/bin/activate && pip install -e .; fi

# R
if [ -f renv.lock ]; then Rscript -e 'renv::restore()'; fi
```

**If no environment file exists, create one** and record exact versions (a lockfile, `pip freeze > requirements.txt`, `conda env export`, or `renv::snapshot()`). Record the language runtime version too. An analysis run against unpinned dependencies is not reproducible.

## Step 3: Fix Random Seeds

Set a single global seed and record it (it belongs in the pre-registration too). Anything stochastic — sampling, splits, bootstrap, model init, cross-validation folds — must use it.

```python
SEED = 20260528
import os, random, numpy as np
os.environ["PYTHONHASHSEED"] = str(SEED)
random.seed(SEED); np.random.seed(SEED)
# torch.manual_seed(SEED); etc.
```

## Step 4: Data Provenance & Immutability

- **Raw data is immutable.** Put it under `data/raw/` and treat it as read-only. Every transform writes a NEW artifact under `data/derived/`. Never edit raw in place.
- **Record provenance:** where each raw file came from, when, which version/query, and a checksum.

```bash
mkdir -p data/raw data/derived
shasum -a 256 data/raw/* > data/raw/CHECKSUMS.txt   # detect silent changes later
chmod -w data/raw/* 2>/dev/null || true             # best-effort read-only
```

- Keep raw and derived separate so a reviewer can see exactly what came in and what you made.

## Step 5: Verify a Clean Baseline

Before adding new work, confirm the workspace starts clean and existing analyses reproduce:

```bash
# Run existing tests / re-run an existing analysis and confirm outputs match
pytest 2>/dev/null || true
```

**If existing results don't reproduce:** report it and ask whether to fix the baseline before proceeding. You can't attribute new findings to your work if the starting point was already broken.

### Report

```
Workspace ready at <path> (branch <name>)
Environment pinned: <python 3.x / conda env>, lockfile recorded
Seed fixed: <SEED>
Raw data: <N files>, checksummed, read-only
Baseline: <reproduces / N tests pass>
Ready to execute <topic>
```

## Quick Reference

| Situation | Action |
|-----------|--------|
| Already in a linked worktree | Skip creation (Step 0) |
| In a submodule | Treat as normal repo |
| Native worktree tool available | Use it |
| No environment file | Create one + record a lockfile |
| Stochastic step | Use the recorded global seed |
| Need to transform raw data | Write a new derived artifact; never edit raw |
| Baseline doesn't reproduce | Report + ask before proceeding |

## Red Flags

**Never:**
- Run an analysis against unpinned dependencies
- Leave seeds unset for anything stochastic
- Edit raw data in place
- Skip the baseline reproducibility check
- Use `git worktree add` when a native worktree tool exists

**Always:**
- Detect existing isolation first
- Pin the environment and record a lockfile
- Fix and record the seed
- Keep raw immutable and provenance documented
- Confirm the baseline reproduces
