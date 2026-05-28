---
name: reporting-and-archiving-findings
description: Use when an analysis is complete and verified, and you need to decide how to report it and archive the work for reproducibility
---

# Reporting and Archiving Findings

## Overview

Complete an investigation by confirming reproducibility, presenting clear options, handling the chosen one, and archiving everything needed to reproduce the result.

**Core principle:** Confirm reproducibility -> separate confirmatory from exploratory -> present options -> execute choice -> archive code + data + environment + pre-registration.

**Announce at start:** "I'm using the reporting-and-archiving-findings skill to complete this work."

## Step 1: Verify Reproducibility

Before reporting anything, confirm the whole analysis reproduces from immutable raw data with the fixed seed in the pinned environment.

```bash
# From a clean state: re-run the pipeline end to end
# Confirm headline numbers match what you intend to report
```

Use `science-superpowers:verifying-results-before-claiming`. **If it doesn't reproduce, stop** — fix reproducibility (possibly via `science-superpowers:investigating-anomalous-results`) before reporting. Don't report a number you can't regenerate.

## Step 2: Detect Environment

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

- `GIT_DIR == GIT_COMMON`: normal repo, no worktree cleanup needed
- `GIT_DIR != GIT_COMMON`, named branch: worktree, provenance-based cleanup (Step 5)
- Detached HEAD: reduced menu (no local merge), no cleanup (externally managed)

## Step 3: Determine Base Branch

```bash
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main — correct?"

## Step 4: Present Options

**Normal repo / named-branch worktree — present exactly these 4 options:**

```
Analysis complete and reproducible. What would you like to do?

1. Merge the analysis back to <base-branch> locally
2. Write up and share (report / preprint / pull request)
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Detached HEAD — present these 3 (no local merge):**

```
Analysis complete and reproducible (externally managed workspace).

1. Push as a new branch and open a pull request / share
2. Keep as-is
3. Discard this work

Which option?
```

Don't add explanation — keep options concise.

## Step 5: Execute Choice

### Option 1: Merge Locally
```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
git checkout <base-branch> && git pull && git merge <feature-branch>
# Re-run the pipeline on the merged result; confirm it still reproduces
```
Then cleanup worktree (Step 6), then `git branch -d <feature-branch>`.

### Option 2: Write Up and Share

Produce the report (see "Report Content" below). If sharing via PR:
```bash
git push -u origin <feature-branch>
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Question
<the research question>

## What was done
<the pre-registered analysis, and any documented deviations>

## Findings
<confirmatory results with effect sizes + intervals>

## Exploratory (not confirmatory)
<clearly separated leads>

## Reproducibility
- Pre-registration: <path/commit>
- Environment: <lockfile>
- Seed: <value>
- Re-run: <command>
EOF
)"
```
**Do NOT clean up the worktree** — it's needed for iteration on feedback.

### Option 3: Keep As-Is
Report: "Keeping branch <name>. Worktree preserved at <path>." No cleanup.

### Option 4: Discard
Confirm first:
```
This will permanently delete:
- Branch <name>
- All commits: <list>
- Worktree at <path>

Type 'discard' to confirm.
```
Wait for the exact word. Then cleanup worktree (Step 6) and `git branch -D <feature-branch>`.

## Step 6: Cleanup Workspace

**Only for Options 1 and 4.** Options 2 and 3 preserve the worktree.

```bash
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```

- `GIT_DIR == GIT_COMMON`: normal repo, nothing to clean up.
- Worktree under `.worktrees/`, `worktrees/`, or `~/.config/superpowers/worktrees/`: we own it.
  ```bash
  MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
  cd "$MAIN_ROOT"
  git worktree remove "$WORKTREE_PATH"
  git worktree prune
  ```
- Otherwise: the harness owns it. Don't remove it.

## Report Content

Every report MUST:

- **Separate confirmatory from exploratory.** Confirmatory results are those that match the frozen pre-registration, run as registered. Everything else goes under an "Exploratory" heading and is described as a lead, not a conclusion.
- **Report effect sizes and intervals**, not just p-values. Describe null results as inconclusive vs. evidence of absence honestly.
- **Document every deviation** from the pre-registration and note that the affected analysis is exploratory.
- **State limitations and threats to validity** carried from the design.
- **Avoid over-claiming** — no causal language from observational data; no generalizing past the sample.

## Archive for Reproducibility

Whatever the option, ensure the archive contains everything needed to regenerate the result:

- The code (committed)
- The environment lockfile and runtime version
- The fixed seed
- The frozen pre-registration (commit reference)
- Data provenance + checksums for raw inputs (and the data itself, or instructions to obtain it, per any data-sharing constraints)
- The exact command(s) to re-run

## Red Flags

**Never:**
- Report a number you haven't just reproduced
- Blur confirmatory and exploratory results
- Report a p-value without an effect size and interval
- Use causal language for an observational finding
- Hide a deviation from the pre-registration
- Remove a worktree before confirming a merge succeeded
- Clean up a worktree you didn't create

**Always:**
- Verify reproducibility before offering options
- Present exactly 4 options (3 for detached HEAD)
- Get typed confirmation for discard
- Archive code + env + seed + pre-registration together
