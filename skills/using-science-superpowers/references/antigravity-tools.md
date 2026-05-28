# Google Antigravity Tool Mapping

Antigravity natively supports **Agent Skills** — directory-based `SKILL.md`
packages in the exact format these skills use. Antigravity loads only a skill's
`description` until your request matches it, then equips the full `SKILL.md`.
This on-demand, intent-triggered loading is the behavior these skills expect.

Skills are written with Claude Code tool names. When you encounter one, use your
Antigravity equivalent. Tool names vary slightly across Antigravity surfaces
(IDE, CLI); match by purpose if a name differs.

| Skill references | Antigravity equivalent |
|------------------|------------------------|
| `Read` (file reading) | `view_file` (read-file tool) |
| `Write` (file creation) | write-file tool |
| `Edit` (file editing) | edit / `replace` tool |
| `Bash` (run commands) | `run_command` |
| `Grep` (search file content) | `grep` / code search |
| `Glob` (find files by name) | file search / `glob` |
| `TodoWrite` (task tracking) | Antigravity task list / plan artifact |
| `Skill` tool (invoke a skill) | Antigravity equips skills automatically; to force one, name it: "use the framing-research-questions skill" |
| `WebSearch` | web search tool |
| `WebFetch` | web fetch / browser tool |
| `Task` tool (dispatch subagent) | Antigravity subagent delegation (see below) |

## Skills are agent-triggered — the bootstrap rule still matters

Because Antigravity equips skills only once your intent matches a `description`,
a skill cannot guarantee it runs *before* you act. The always-on
`using-science-superpowers` bootstrap **Rule** is what guarantees the discipline
— most importantly the `framing-research-questions` HARD GATE — is in effect
from the first message, before any data is touched. Keep that rule installed
(see `.antigravity/INSTALL.md`).

## Subagent support

Several skills dispatch a fresh subagent with a filled prompt template. In
Antigravity, use its subagent / delegation capability and pass the complete
filled template as the subagent's task:

| Skill instruction | Antigravity equivalent |
|-------------------|------------------------|
| `Task tool (science-superpowers:analyst)` | Subagent with the filled `analyst-prompt.md` |
| `Task tool (science-superpowers:protocol-compliance-reviewer)` | Subagent with the filled `protocol-compliance-reviewer-prompt.md` |
| `Task tool (science-superpowers:rigor-reviewer)` | Subagent with the filled `rigor-reviewer-prompt.md` |
| `Task tool (science-superpowers:red-team-reviewer)` | Subagent with the filled `reviewer.md` |
| `Task tool (general-purpose)` with inline prompt | Subagent with your inline prompt |

The prompt template itself contains the subagent's role, review criteria, and
required output format — the subagent follows it. Fill every placeholder (e.g.
`{WHAT_WAS_ANALYZED}`) before dispatching.

If subagent delegation is unavailable in your Antigravity surface, run the step
inline in a clean context and apply the same prompt to yourself, preserving the
reviewer's independent, adversarial stance. A non-independent review is weaker
evidence — note that limitation in your findings.

### Parallel dispatch

When a skill dispatches independent subagents in parallel (e.g.
`dispatching-parallel-investigations`), launch them concurrently rather than
serializing. Keep dependent steps sequential.

## MCP and additional tools

Antigravity connects MCP servers (configured under `~/.gemini/`) for live data
sources such as databases and issue trackers. Treat MCP-provided data as input
to an analysis — it does not change the methodology. Frame the question and
pre-register predictions before drawing any confirmatory conclusion from
MCP-sourced data.
