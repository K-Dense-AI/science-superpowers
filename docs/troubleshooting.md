# Troubleshooting

[Documentation](README.md) · [Installation](installation.md) · [Pre-registration](preregistration.md)

Start by distinguishing three things: the harness discovered the skill files, the
bootstrap loaded, and the agent followed the intended behavior. Each needs its
own evidence.

## Skills do not appear

Check the harness-specific [installation guide](installation.md), then inspect
the installed copy. Each skill needs its own directory with a `SKILL.md` containing
`name` and `description` frontmatter. A checkout on disk is not necessarily an
installed plugin.

For symlink installations, inspect the links and confirm their targets still
exist. A moved or deleted clone breaks those links. Avoid loading duplicate
copies from a plugin and a native skills directory while diagnosing discovery.

For Cursor local plugins, check local-import policy and whether a marketplace
installation takes precedence. For Codex's native setup, check `.agents/skills`
in the research repository. For OpenCode, Pi, and Antigravity, use the checks in
their [dedicated integration guides](installation.md#opencode-pi-and-antigravity).

## The agent starts analyzing before framing

Open a fresh session and explicitly request
`science-superpowers:using-science-superpowers`, then
`science-superpowers:framing-research-questions`. If manual invocation works,
inspect the bootstrap path for your harness:

- Cursor: the manifest's hook path, `sessionStart` registration, and Bash execution.
- Claude Code: the `SessionStart` hook and installed plugin root.
- Codex or portable skill-only setup: explicitly invoke the bootstrap; skill
  discovery alone does not establish startup injection.
- Gemini CLI: the extension's `GEMINI.md` context imports.
- OpenCode: the loaded adapter and its message transform.
- Pi: the package extension and `Science Superpowers loaded` notification.
- Antigravity: both the skill directories and the always-on bootstrap rule.

The [Cursor contract smoke test](contributing.md#cursor-hook-contract-smoke-test)
checks JSON generation separately from harness loading. If bootstrap text is
present but behavior still fails, capture the prompt and actual response for a
behavioral regression scenario. Missing bootstrap is not the only possible cause.

If confirmatory outcomes were already examined, preserve that fact and label the
affected analysis exploratory. Repeating the prompt does not undo exposure.

## A hook is silent or returns the wrong JSON shape

The wrapper runs Bash. On Windows, no available Bash means the wrapper exits
silently. On Unix, a missing Bash executable prevents the hook from running.
Check the executable and installed file paths before changing configuration.

The [hook's environment mapping](contributing.md#shell-hook-output) determines the
payload field. A direct shell invocation without harness variables uses the
fallback `additionalContext` field. That does not test the Cursor payload, which
requires `CURSOR_PLUGIN_ROOT`.

Check that the bootstrap source file is readable. Do not solve duplicate context
by emitting every harness field: the implementation deliberately emits one shape
to avoid duplicate injection.

## Updates are not visible

Confirm which checkout or cached plugin the harness loaded. Refresh through the
original installation mechanism and restart the session. OpenCode and Pi cache
bootstrap content in memory. Copies of Antigravity rules do not update when the
source clone changes. A symlink to each existing skill also does not automatically
create a link for a newly added skill directory.

## The harness has no subagent tool

Use `science-superpowers:executing-analysis` for inline execution. Follow the
harness's tool mapping and retain explicit validation and review checkpoints.
Describe review performed in the same context as inline review; do not claim that
an independent reviewer ran. Installing the skill library does not create a
subagent capability.

## A pre-registration cannot be frozen

| Message or symptom | Action |
| --- | --- |
| `not inside a git repository` | Run from the research repository root |
| `repository has no commits yet` | Commit a clean baseline without the registration, then freeze the new file |
| `already has git history` | Do not rewrite history to manufacture a freeze; create a new registration for a fresh test on unused outcomes |
| Git asks for author identity or fails signing | Configure the research repository's normal commit identity and signing setup, then inspect what the failed command already changed |
| Missing input file | Correct the path and inspect the uncommitted registration before retrying |
| Paths contain whitespace | Use a workspace and study paths without whitespace; the helper does not support them |
| An inside-repository file is reported as outside, or audit shows doubled absolute paths | Run `cd -P .` at the repository root and use relative file arguments; the helper can confuse symlink aliases with Git's physical root |

`freeze` is not transactional: it may append checksums before encountering an
error, or create the freeze commit before a stamp-commit failure. Inspect
`git status`, the document, and recent history before retrying. If there is no
freeze commit, remove only partial additions from the failed attempt before
retrying. If the file already has a freeze commit, preserve it and investigate
the partial state; a second `freeze` will reject it.

## A pre-registration audit fails

Read the individual checks, not just the final status. Preserve evidence of the
failure and determine whether it concerns this study or an incorrectly broad
output scope.

| Check | What to investigate |
| --- | --- |
| `FROZEN` | Was the registration ever committed, and is the relevant history available? |
| `STAMP` | Does the document claim the actual first commit? Inspect history; do not invent a timestamp |
| `INTEGRITY` | Compare the frozen, `HEAD`, and working versions. A changed analysis needs documented deviations and exploratory labeling |
| `CHRONOLOGY` | Which output commits precede the freeze? Scope unrelated studies separately, while retaining all outputs of the current study |
| `DATA` | Is the original input missing or modified? Recover the original version from provenance when appropriate; preserve changed data as a new version |

Do not delete early output commits or rewrite a registration to make the record
appear valid. A passing record must reflect what happened. If the prediction or
method was chosen after outcomes were known, the affected analysis is exploratory;
confirmation requires a new registration and unused data or runs.

## The audit passes, but the evidence looks incomplete

Exit status `0` can include warnings, missing stamps, absent checksum protection,
or no committed outputs. Read [audit scope](preregistration.md#audit-scope) and
[limits](preregistration.md#limits-of-a-passing-audit). In particular, include
`data/derived/` explicitly when it contains study outputs, and inspect parallel
branch warnings. The audit does not check whether the code implements the plan.

## Can I explore, reproduce published work, or fix a bug?

Yes. Exploration is a valid activity and should be labeled as such. The
registration skill discusses descriptive work, simulated method development, and
re-analysis of public results as cases to decide with your human partner. None
turn already-observed outcomes into fresh confirmation.

Feasibility mode has its own explicit entry and exit decisions. A successful
campaign does not automatically authorize a confirmatory study.

A verified implementation fix that restores the registered analysis differs from
choosing a new method after seeing results. Document the fix, rerun the affected
steps, and verify again. New analytic choices are deviations and change the status
of the affected analysis. See [handling changes](research-workflow.md#when-the-plan-changes).

## What to include in a bug report

Provide the harness and version, installation method, library commit or version,
minimal prompt or command, expected behavior, actual response or error, and
relevant hook or audit output. Include a small reproducible fixture where possible.
Keep credentials and private research data out of the report.
