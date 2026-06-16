# Installing Science Superpowers for Pi

## Prerequisites

- [Pi](https://pi.dev) installed (`npm install -g @earendil-works/pi-coding-agent`)

## How it maps to Pi

Pi natively supports the two primitives this project needs:

| Science Superpowers piece | Pi primitive |
|---------------------------|--------------|
| The workflow skills (`framing-research-questions`, `preregistering-analysis`, …) | Agent **Skills** — same `SKILL.md` format Pi already reads |
| `using-science-superpowers` bootstrap | A TypeScript **extension** (`before_agent_start`) that injects the bootstrap into the system prompt |
| Claude Code tool names in skills | `skills/using-science-superpowers/references/pi-tools.md` |

The repo is a Pi **package**: its `package.json` declares the `skills/` directory and the
bootstrap extension under the `pi` key, so a single install wires up both.

## Installation

Install the package from git (global, all projects):

```bash
pi install git:github.com/K-Dense-AI/science-superpowers
```

Or pin a tag/commit:

```bash
pi install git:github.com/K-Dense-AI/science-superpowers@v0.1.0
```

You can also install from a local clone:

```bash
pi install /path/to/science-superpowers
```

Pi installs the package, registers every skill, and loads the bootstrap extension. The
extension injects `using-science-superpowers` at session start so the discipline —
especially the `framing-research-questions` HARD GATE — is active from the first message.

Pi uses its own package manager. If you also use Claude Code, Cursor, Codex, Gemini CLI,
OpenCode, or Antigravity, install Science Superpowers separately for each — see the
project README.

## Verify

Open a fresh Pi session. On startup you should see a `Science Superpowers loaded`
notification. Then send exactly:

> Let's analyze this dataset

A working install responds by equipping **framing-research-questions** and helping you
turn the request into a precise, falsifiable question. It does **not** start loading,
profiling, or plotting the data. If it dives into the data, the bootstrap extension is not
loading — see Troubleshooting.

You can also run `/skill:` (tab-complete) to confirm the skills are discovered, or ask
"Tell me about your science superpowers."

## Usage

You don't invoke anything — the skills trigger themselves once the bootstrap is loaded.
Pi also exposes each skill as a `/skill:name` command (e.g. `/skill:framing-research-questions`)
if you want to load one explicitly.

When a skill references a Claude Code tool name (`Read`, `Bash`, `Task`, `TodoWrite`, …),
use the Pi equivalent from `skills/using-science-superpowers/references/pi-tools.md`.

> **Sub-agents:** Pi intentionally ships without sub-agents. Skills that dispatch
> subagents (`subagent-driven-analysis`, `dispatching-parallel-investigations`,
> `requesting-red-team-review`) still work — run the dispatched work inline with explicit
> role separation, or install a Pi package that adds sub-agents. See the
> "Subagent dispatch" section of `references/pi-tools.md`.

## Updating

Pi resolves git-backed packages to a specific commit. Re-run the install to pick up the
newest commit:

```bash
pi install git:github.com/K-Dense-AI/science-superpowers
```

For a local clone, `git pull` then re-run `pi install /path/to/science-superpowers`.

## Troubleshooting

### `framing-research-questions` does not gate the data

The bootstrap extension is not loading. Confirm the package installed
(`pi install` reported success) and restart Pi. You should see the
`Science Superpowers loaded` notification at session start.

### Skills are not discovered

- Tab-complete `/skill:` to list discovered skills.
- Confirm the package's `package.json` declares `"skills": ["./skills"]` under the `pi`
  key and that the `skills/` directory contains the `SKILL.md` packages.

### A skill references a Claude Code tool name

See `skills/using-science-superpowers/references/pi-tools.md` for the Pi equivalents.
