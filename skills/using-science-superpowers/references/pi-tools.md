# Pi Tool Mapping

Skills use Claude Code tool names. When you encounter these in a skill, use your Pi
([pi.dev](https://pi.dev)) equivalent:

| Skill references | Pi equivalent |
|-----------------|---------------|
| `Read` (file reading) | `read` |
| `Write` (file creation) | `write` |
| `Edit` (file editing) | `edit` |
| `Bash` (run commands) | `bash` |
| `Grep` (search file content) | `grep` |
| `Glob` (search files by name) | `find` (or `ls`) |
| `Skill` tool (invoke a skill) | Skills load natively — see [Loading skills](#loading-skills) |
| `TodoWrite` (task tracking) | No native equivalent — see [Tracking checklists](#tracking-checklists) |
| `Task` tool (dispatch subagent) | No native equivalent — see [Subagent dispatch](#subagent-dispatch) |
| `WebSearch` / `WebFetch` | No native web tools — use `bash` (e.g. `curl`) or an installed package |

## Loading skills

Pi auto-discovers skills and lists their names and descriptions in your system prompt.
When a task matches a skill, use `read` to load its `SKILL.md` and follow it directly —
that *is* invoking the skill. Skills are also exposed as `/skill:name` commands for the
user. The `using-science-superpowers` bootstrap is already loaded into your system prompt
at session start; do not re-load it.

## Tracking checklists

Pi intentionally ships without a to-do tool. When a skill says to create a TodoWrite item
per checklist step, instead keep the checklist explicit in your replies: list the steps,
mark each one done as you complete it, and do not skip ahead. The discipline is the
checklist, not the tool.

## Subagent dispatch

Pi intentionally ships without sub-agents. Skills that dispatch subagents
(`subagent-driven-analysis`, `dispatching-parallel-investigations`,
`requesting-red-team-review`) still work — you have two options:

1. **Install a Pi package that adds sub-agents**, then map dispatch to that package's
   mechanism. This is the closest match to the skill's intent (fresh context per task,
   true independence).

2. **Run the dispatched work inline** in the current session, preserving the role
   separation the skill requires. Take the skill's prompt template, fill every
   placeholder, and execute it as a distinct, self-contained pass — then switch roles and
   review against the template's criteria. State which role you are in at each step.

| Skill instruction | Inline equivalent |
|-------------------|-------------------|
| `Task tool (science-superpowers:analyst)` | Execute the filled `analyst-prompt.md` template as a focused analysis pass |
| `Task tool (science-superpowers:protocol-compliance-reviewer)` | Re-read the work against the filled `protocol-compliance-reviewer-prompt.md` criteria |
| `Task tool (science-superpowers:rigor-reviewer)` | Re-read the work against the filled `rigor-reviewer-prompt.md` criteria |
| `Task tool (science-superpowers:red-team-reviewer)` | Attack the analysis using the filled `reviewer.md` template |
| `Task tool (general-purpose)` with inline prompt | Execute the inline prompt as a focused pass |

Inline execution loses the context isolation a true subagent gives you. When a skill's
rigor depends on an *independent* reviewer (red-team review, two-stage compliance/rigor
review), prefer option 1, or be explicit that the review was self-administered so your
human partner can weigh it accordingly.

### Parallel dispatch

Without sub-agents, independent investigations that a skill would run in parallel must run
sequentially. Keep each one self-contained and labeled; do not let findings from one bleed
into another. Note in your report that they were run sequentially.

## Environment detection

Skills that set up reproducible workspaces or finish investigations should detect their
environment with read-only git commands before proceeding:

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

- `GIT_DIR != GIT_COMMON` → already in a linked worktree (skip creation)
- `BRANCH` empty → detached HEAD (cannot branch/push)

See `setting-up-reproducible-analysis` Step 0 and `reporting-and-archiving-findings`
for how each skill uses these signals.
