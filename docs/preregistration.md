# Freeze and audit a pre-registration

[Documentation](README.md) · [Research workflow](research-workflow.md) · [Troubleshooting](troubleshooting.md)

`prereg.sh` records a registration in Git and audits the relationship between that
registration, committed outputs, and optional input checksums. It ships with
`science-superpowers:preregistering-analysis`.

The methodological requirement is stronger than the script: freeze the prediction
**before observing confirmatory outcomes**, run the registered method, and label
deviations exploratory. An audit cannot establish what someone saw outside Git.

## Prepare a real registration

Use the [registration skill's template](../skills/preregistering-analysis/SKILL.md)
to specify hypotheses, exact analysis, predictions, decision rules, sample size
and stopping, multiplicity, and exploratory work. Include a possible result that
would disconfirm the prediction. Resolve feasibility using separate validation
cases before freezing.

Save the new file under
`docs/science-superpowers/preregistrations/YYYY-MM-DD-<topic>.md` in the research
repository. Keep it uncommitted until `freeze`: the freeze must be its **first
commit**. Commit the question, design, and baseline separately beforehand.

## Runnable walkthrough

This exercise tests the mechanics with a known-answer fixture. It is not a
scientific study or empirical evidence. Run the blocks in order in the same shell,
starting at the root of a Science Superpowers checkout. All commits occur in a new
temporary repository; the library checkout is only read.

### 1. Create a baseline

```sh
SCIENCE_SUPERPOWERS_DIR="$(pwd -P)"
PREREG_SCRIPT="$SCIENCE_SUPERPOWERS_DIR/skills/preregistering-analysis/prereg.sh"
test -f "$PREREG_SCRIPT" || exit 1
PREREG_DEMO="$(mktemp -d)"
cd -P "$PREREG_DEMO" || exit 1
PREREG_DEMO="$(pwd -P)"
git init -q
git config user.name "Pre-registration demo"
git config user.email "prereg-demo@example.invalid"
git config commit.gpgsign false
mkdir -p docs/science-superpowers/preregistrations data/raw
printf '# Pre-registration mechanics demo\n' > README.md
printf 'id,value\n1,2\n2,4\n' > data/raw/fixture.csv
git add README.md data/raw/fixture.csv
git commit -q -m "demo: clean baseline"
```

### 2. Write and freeze a new registration

The fixture values are deliberately known. This short document tests recordkeeping;
use the full skill template for research.

```sh
cat > docs/science-superpowers/preregistrations/2026-01-01-demo.md <<'EOF'
# Pre-registration mechanics demo

**Frozen at commit:** <stamped by prereg.sh freeze>

## Scope
Known-answer software fixture only; no scientific or inferential claim.

## Prediction and procedure
Read both rows of data/raw/fixture.csv and sum the value column using awk.
The output must be exactly sum=6. Any other output fails the fixture check.
Use every row, with no exclusions, transformations, random steps, or retries
that change the procedure. Write the output to results/demo/sum.txt.
EOF

sh "$PREREG_SCRIPT" freeze \
  docs/science-superpowers/preregistrations/2026-01-01-demo.md \
  data/raw/fixture.csv
```

`freeze` appends a Git blob checksum for the input, commits the registration alone
with a `prereg-freeze:` message, and creates a second `prereg-stamp:` commit to
insert the freeze commit hash. It therefore **writes the document and creates two
commits**. It does not run the analysis or commit the raw input for you.

### 3. Produce and commit an output

```sh
mkdir -p results/demo
awk -F, 'NR > 1 { total += $2 } END { print "sum=" total }' \
  data/raw/fixture.csv > results/demo/sum.txt
cat results/demo/sum.txt
git add results/demo/sum.txt
git commit -q -m "demo: record fixture output"
```

Expected output: `sum=6`.

### 4. Audit the record

```sh
sh "$PREREG_SCRIPT" audit --results results/demo \
  docs/science-superpowers/preregistrations/2026-01-01-demo.md
```

Expect `PASS` for `FROZEN`, `STAMP`, `INTEGRITY`, `CHRONOLOGY`, and `DATA`, followed
by `RESULT: PASS (0 warning(s))`. Commit hashes and dates vary.

For a real investigation, run the audit before execution and again after committing
the outputs, before reporting. Before execution, “no committed outputs found” is
expected; at reporting time, confirm the paths cover the actual outputs.

The temporary repository remains available for inspection. Return to the library
checkout with `cd "$SCIENCE_SUPERPOWERS_DIR"` when finished.

## Command reference

```text
prereg.sh freeze <prereg-file> [raw-data-file ...]
prereg.sh audit [--results <path>] [prereg-file ...]
prereg.sh help
```

Run from the research repository root using its physical path (`cd -P .` avoids
symlink aliases such as macOS `/var` versus `/private/var`). Use
`sh /path/to/prereg.sh` if the helper is not executable. The repository needs an initial commit and a configured Git
identity before freezing. Use paths without whitespace; the script does not
support whitespace-containing paths. Keep registration and input files inside
the repository.

| Command | Behavior |
| --- | --- |
| `freeze` | Rejects a registration with existing history; optionally records raw-input Git blob hashes; creates the freeze and stamp commits |
| `audit` | Reads Git history and current files; defaults to immediate `*.md` files in `docs/science-superpowers/preregistrations/` |
| `audit --results PATH` | Uses the specified output scope instead of the defaults; repeat the flag for multiple paths |
| `help` | Prints the script's usage and check descriptions |

The audit returns `0` when no checks fail, **including runs with warnings**; `1`
when a check fails; and `2` for reported usage or setup errors. Shell or Git failures
may propagate their own nonzero status. Always inspect the output as well as the
exit code.

## Audit scope

Default output paths are the repository-root directories `results`, `outputs`,
`figures`, `reports`, and `derived`, when present or represented in Git history.
They do not include every generated file in the repository.

For a study with nested derived data and separate reports:

```sh
sh "$PREREG_SCRIPT" audit \
  --results data/derived/solver-comparison \
  --results results/solver-comparison \
  --results reports/solver-comparison \
  docs/science-superpowers/preregistrations/2026-09-13-solver-comparison.md
```

This is an example for a real study, separate from the runnable demo. Supply all
of that study's output locations. In a repository containing several studies,
pass the relevant registration explicitly too: an unscoped audit compares each
discovered registration with the same output paths. Do not narrow the scope to
hide early outputs from the study being audited.

## What each check establishes

| Check | What the implementation checks |
| --- | --- |
| `FROZEN` | The file has a first commit in the available history; that commit is treated as the freeze |
| `STAMP` | A hexadecimal hash in the working document matches the freeze hash prefix; a missing or non-hash stamp produces informational output |
| `INTEGRITY` | The version at `HEAD` and the working file match the frozen content after normalizing the stamp line and its inserted blank line |
| `CHRONOLOGY` | No reachable commit touching a selected output path is an ancestor of, or equal to, the freeze commit |
| `DATA` | Listed frozen raw-input Git blob hashes match the current files; this check is conditional on a checksum section |

## Limits of a passing audit

The helper is a consistency check within the available Git record. It does not
prove that outcomes were unseen, that the registered method was followed, or that
the scientific conclusion is correct. In particular:

- An uncommitted, ignored, external, or out-of-scope result may have existed before
  the freeze without failing chronology. No committed outputs is informational.
- Output commits on parallel branches can have unprovable ordering. The script
  warns and may still return success.
- Integrity compares the frozen version with `HEAD` and the working tree. An
  intermediate edit that was later reverted is not detected by that comparison.
- The audit derives the freeze from the first commit; it does not enforce the
  `prereg-freeze:` message or require that the first commit contained only that file.
- Git history can be rewritten, and a shallow checkout may omit relevant history.
  The audit is not an independent timestamping or public registration service.
- Omitting raw-input arguments at freeze time omits their checksum protection.

Keep complete study history, inspect warnings, verify the actual analysis, and
preserve external registration evidence when your study requires it. A failed
audit needs investigation; see [failure handling](troubleshooting.md#a-pre-registration-audit-fails).
