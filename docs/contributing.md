# Contributing

[Documentation](README.md) · [Skills reference](skills-reference.md) · [Contributor instructions](../AGENTS.md)

Keep each change focused on one problem. The repository's `AGENTS.md` points to
`CLAUDE.md`; read those instructions before editing. Changes to skill behavior
require the evidence-driven authoring process below, including changes described
as “documentation updates” when they modify a skill.

## Repository architecture

| Location | Responsibility |
| --- | --- |
| `skills/<name>/SKILL.md` | Agent instructions with `name` and `description` frontmatter |
| `skills/using-science-superpowers/` | Bootstrap and harness tool mappings |
| `skills/preregistering-analysis/prereg.sh` | Git-based registration freeze and audit |
| `hooks/session-start` | Reads the bootstrap and emits a harness-specific JSON payload |
| `hooks/run-hook.cmd` | Unix/Windows wrapper that finds Bash and invokes the hook |
| `hooks/hooks-cursor.json`, `hooks/hooks.json` | Cursor and Claude Code event registrations |
| `plugin.json` | Portable Agent Plugins manifest |
| `.cursor-plugin/`, `.claude-plugin/`, `.codex-plugin/` | Harness-specific manifests and marketplace metadata |
| `gemini-extension.json`, `GEMINI.md` | Gemini extension metadata and bootstrap imports |
| `.opencode/plugins/science-superpowers.js` | Skill-path registration and bootstrap insertion into the first user message |
| `.pi/extensions/science-superpowers.ts` | Pi bootstrap extension, registered by `package.json` |
| `.antigravity/` | Installation instructions and bootstrap rule |
| `scripts/` | Regression checks and version maintenance |
| `docs/` | Human-facing user and contributor guides |

At startup, the harness adapter makes the bootstrap available. The bootstrap
directs the agent to load relevant skills, whose descriptions provide discovery
triggers. Full skill bodies carry the behavior. The shared library does not need
a build step or third-party runtime packages.

### Shell hook output

The hook chooses exactly one output shape:

| Environment | JSON field |
| --- | --- |
| Nonempty `CURSOR_PLUGIN_ROOT` | `additional_context` |
| Nonempty `CLAUDE_PLUGIN_ROOT`, with no `COPILOT_CLI` | `hookSpecificOutput.additionalContext`, with `hookEventName: SessionStart` |
| Other environments | Top-level `additionalContext` |

Cursor detection takes precedence. The script locates its source files relative
to itself; these environment variables select the output format. The fallback
payload alone does not constitute a complete integration with another harness.

## Author or change a skill

Use [science-superpowers:writing-science-skills](../skills/writing-science-skills/SKILL.md).
Skills are behavioral interventions, so editorial plausibility is not sufficient
validation.

1. **RED:** Create a pressure or application scenario and run a fresh agent without
   the skill. Record the actual failure and exact rationalizations. Discipline
   scenarios should combine at least three pressures, such as deadline, sunk cost,
   and an apparently authoritative request.
2. **GREEN:** Make the smallest skill change that addresses the observed failure.
   Rerun the scenario with the skill and inspect the agent's choices and artifacts.
3. **REFACTOR:** Add counterexamples and new pressures. Close demonstrated loopholes
   and rerun until the behavior holds.

Finish testing one skill before beginning another. Include the scenarios, baseline
evidence, intervention, and observed outcomes with the change so reviewers can
assess the behavioral effect.

### Authoring rules

- Use a descriptive name containing only letters, numbers, and hyphens. Keep one
  `SKILL.md` in each immediate subdirectory of the root `skills/` directory.
- Include `name` and `description` frontmatter. The authoring skill limits the
  frontmatter to 1024 characters in total.
- Describe **when to use** the skill, using concrete triggers. Do not put a summary
  of the procedure into `description`.
- Preserve Iron Laws, Red Flags, rationalization tables, and letter-versus-spirit
  framing when they carry tested behavior. Preserve “your human partner.”
- Keep confirmatory and exploratory analysis distinct. Domain-specific tools and
  dependencies belong in a separate plugin.
- Reference other skills as `science-superpowers:<skill-name>`, with an explicit
  requirement marker when required. Do not use force-loading `@` links.
- Keep ordinary guidance technology-agnostic. A technology-specific skill needs
  explicit technology-specific triggers.

For human-facing guide edits that do not change a skill, validate the prose,
links, and examples against the implementation. Do not change a `SKILL.md` as a
side effect without its required baseline test.

## Validate your change

Run commands from the repository root. Match the checks to the files changed and
record actual results in the review description.

### Cursor hook contract smoke test

This check uses `jq` as a **developer tool**. The runtime hook does not require it.
Run in Bash so `pipefail` propagates a failing hook command:

```bash
set -o pipefail
CURSOR_PLUGIN_ROOT="$PWD" bash hooks/run-hook.cmd session-start |
  jq -e '
    (keys == ["additional_context"]) and
    (.additional_context | contains("You have science superpowers.")) and
    (.additional_context | contains("name: using-science-superpowers"))
  '
```

Expected result: `true` and exit status `0`. This validates the Cursor payload
contract. It does not prove that Cursor loaded the plugin or that an agent follows
the skills.

Also test behavior in at least one harness: install the changed checkout, open a
fresh conversation, and use the [installation verification prompt](installation.md#verify-every-installation).
For a skill change, run its specific baseline and intervention scenarios too.
Record the harness, how the checkout was loaded, and observed behavior.

### Pre-registration regression checks

When changing the helper or documenting its behavior, run:

```sh
sh scripts/test-prereg.sh
```

The suite creates and removes throwaway repositories. Its five cases cover freeze
with and without a stamp placeholder, a current post-freeze edit, an output
committed before freezing, and a changed raw-data file. It prints
`all prereg.sh cases passed` on success. These cases do not cover every
[audit limitation](preregistration.md#limits-of-a-passing-audit).

For hook or shell changes, syntax checks provide another quick check:

```sh
bash -n hooks/session-start hooks/run-hook.cmd scripts/bump-version.sh
sh -n skills/preregistering-analysis/prereg.sh scripts/test-prereg.sh
git diff --check
```

### Documentation checks

Check that relative links and heading anchors resolve, named skills exist, and
commands match their working-directory assumptions. Run the
[temporary-repository walkthrough](preregistration.md#runnable-walkthrough) when
editing it. Mark hypothetical examples clearly and distinguish a simulated hook
check from a live harness test.

## Manifests and versions

The portable root `plugin.json` uses a closed schema. Its only permitted top-level
fields are:

```text
$schema name version description author homepage repository license keywords extensions
```

Do not add `skills`, `hooks`, `agents`, `commands`, or `mcpServers` at the root.
Harness-specific manifests retain their own fields. Client-specific portable
metadata belongs under a reverse-domain key in `extensions`.

The [version configuration](../.version-bump.json) tracks seven version fields.
After touching any manifest, run:

```bash
scripts/bump-version.sh --check
```

For an intended release, pass the chosen `X.Y.Z` version to
`scripts/bump-version.sh`. It updates declared fields and runs an audit for other
version references. `--audit` alone reports possible undeclared references; use
`--check` to enforce version consistency. Both require `jq`.

## Submit a reviewable change

Explain the concrete problem, resulting behavior, and validation. For a skill
change, include the observed baseline failure and post-change evidence. For an
adapter change, name the tested harness and payload behavior. For documentation,
identify the covered use cases and examples actually executed. State any untested
integration rather than implying that all harnesses were exercised.
