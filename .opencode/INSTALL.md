# Installing Science Superpowers for OpenCode

## Prerequisites

- [OpenCode.ai](https://opencode.ai) installed

## Installation

Add science-superpowers to the `plugin` array in your `opencode.json` (global or project-level):

```json
{
  "plugin": ["science-superpowers@git+https://github.com/K-Dense-AI/science-superpowers.git"]
}
```

Restart OpenCode. The plugin installs through OpenCode's plugin manager and
registers all skills.

Verify by asking: "Tell me about your science superpowers"

OpenCode uses its own plugin install. If you also use Claude Code, Codex, or
another harness, install Science Superpowers separately for each one.

## Usage

Use OpenCode's native `skill` tool:

```
use skill tool to list skills
use skill tool to load science-superpowers/framing-research-questions
```

## Updating

OpenCode installs the plugin through a git-backed package spec. Some OpenCode
and Bun versions pin that resolved git dependency in a lockfile or cache, so a
restart may not pick up the newest commit. If updates do not appear, clear
OpenCode's package cache or reinstall the plugin.

## Troubleshooting

### Plugin not loading

1. Check logs: `opencode run --print-logs "hello" 2>&1 | grep -i science`
2. Verify the plugin line in your `opencode.json`
3. Make sure you're running a recent version of OpenCode

### Skills not found

1. Use `skill` tool to list what's discovered
2. Check that the plugin is loading (see above)

### Tool mapping

When skills reference Claude Code tools:
- `TodoWrite` → `todowrite`
- `Task` with subagents → `@mention` syntax
- `Skill` tool → OpenCode's native `skill` tool
- File operations → your native tools
