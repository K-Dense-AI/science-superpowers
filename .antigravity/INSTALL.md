# Installing Science Superpowers for Google Antigravity

Google Antigravity natively supports the two primitives this project needs:

- **Agent Skills** — directory-based `SKILL.md` packages that Antigravity equips
  automatically when your request matches the skill's `description`. This repo's
  `skills/` are already in that exact format.
- **Rules** — always-on instructions Antigravity loads at session start
  (`GEMINI.md`, `AGENTS.md`, and `.agent/rules/*.md`).

The integration is: install the skills, then load the bootstrap rule so the
discipline — especially the `framing-research-questions` HARD GATE — is active
from the first message, before any data is touched.

> Requires Antigravity v1.20.3+ for `AGENTS.md` support. The skills and
> `GEMINI.md` rule work on earlier versions too.

## Option A — Per-workspace install (recommended)

Scopes Science Superpowers to a single project using Antigravity's workspace
`.agent/` convention. This path is consistent across Antigravity versions and
surfaces (IDE and CLI).

```bash
REPO="/path/to/science-superpowers"   # a clone of this repository
cd /path/to/your/project              # the project you'll analyze in

mkdir -p .agent/skills .agent/rules

# 1. Install the skills as workspace Agent Skills
ln -s "$REPO"/skills/* .agent/skills/

# 2. Load the always-on bootstrap rule
cp "$REPO/.antigravity/rules/using-science-superpowers.md" .agent/rules/
```

Open the project in Antigravity (or start a new Agent conversation). Commit
`.agent/` if you want everyone on the project to share the methodology.

## Option B — Global install (all projects)

Makes Science Superpowers available in every workspace.

```bash
REPO="$(pwd)"   # run from a clone of this repository

# 1. Install the skills as global Agent Skills
mkdir -p ~/.gemini/skills
ln -s "$REPO"/skills/* ~/.gemini/skills/

# 2. Load the always-on bootstrap rule at session start
cat "$REPO/.antigravity/rules/using-science-superpowers.md" >> ~/.gemini/GEMINI.md
```

Restart Antigravity.

> **The global skills path varies by build.** Recent Antigravity uses
> `~/.gemini/skills` for skills shared across all Antigravity tools; some builds
> instead read `~/.gemini/antigravity/skills` (IDE) or
> `~/.gemini/antigravity-cli/skills` (CLI). After installing, run `/skills` (CLI)
> or open the Skills panel to confirm discovery; if they don't appear, move the
> `skills/*` symlinks to whichever path your build lists. The per-workspace
> `.agent/skills/` path (Option A) is not subject to this and is the most
> reliable.

> **Also use Gemini CLI?** Antigravity and Gemini CLI both read
> `~/.gemini/GEMINI.md`. To keep their contexts separate, append the bootstrap
> rule to `~/.gemini/AGENTS.md` instead — Antigravity reads it, Gemini CLI does
> not. (Install Science Superpowers for Gemini CLI via its own extension; see the
> project README.)

## Verify

Open a fresh Agent conversation and send exactly:

> Let's analyze this dataset

A working install responds by equipping **framing-research-questions** and
helping you turn the request into a precise, falsifiable question. It does NOT
start loading, profiling, or plotting the data. If it dives into the data, the
bootstrap rule is not loading — re-check step 2 and restart Antigravity.

You can also run `/skills` in the Antigravity CLI to confirm the skills are
discovered, or ask "Tell me about your science superpowers."

## How it maps to Antigravity

| Science Superpowers piece | Antigravity primitive |
|---------------------------|------------------------|
| `using-science-superpowers` bootstrap | Always-on **Rule** (`GEMINI.md` or `.agent/rules/`) |
| The workflow skills (`framing-research-questions`, `preregistering-analysis`, …) | Agent-triggered **Skills** (`.agent/skills/`, or your build's global skills dir) |
| Subagent dispatch inside skills | Antigravity subagent delegation |
| Claude Code tool names in skills | `skills/using-science-superpowers/references/antigravity-tools.md` |

If you also use Claude Code, Cursor, Codex, Gemini CLI, or OpenCode, install
Science Superpowers separately for each — see the project README.

## Updating

If you symlinked `skills/*` (Option A or B), `git pull` in the repo updates the
skills automatically. If you appended the bootstrap rule to `~/.gemini/GEMINI.md`
or copied it into `.agent/rules/`, re-copy it after pulling changes to that file.

## Troubleshooting

### `framing-research-questions` does not gate the data

The bootstrap rule is not loaded. Confirm the rule text is present in
`.agent/rules/using-science-superpowers.md` (Option A) or `~/.gemini/GEMINI.md`
(Option B), then restart Antigravity.

### Skills are not discovered

Run `/skills` (CLI) or open the Skills panel. Check that the symlinks resolve —
e.g. `ls -l .agent/skills/` (Option A) or `ls -l ~/.gemini/skills/` (Option B).
Each entry should point into this repo's `skills/` directory and contain a
`SKILL.md`. If a global install isn't discovered, see the build-path note under
Option B.

### A skill references a Claude Code tool name

See `skills/using-science-superpowers/references/antigravity-tools.md` for the
Antigravity equivalents.
