# Installation

[Documentation](README.md) · [Getting started](getting-started.md) · [Troubleshooting](troubleshooting.md)

Install Science Superpowers separately for each harness you use. A complete setup
has two parts: discovery of the skills and loading of
`science-superpowers:using-science-superpowers`, the bootstrap that directs the
agent to use them.

## Requirements

| Component | Requirements |
| --- | --- |
| Skill library | An agent harness that can discover and read `SKILL.md` files; no third-party runtime packages |
| Cursor and Claude Code hooks | Bash and standard shell utilities; the bundled hook implementation uses Bash features |
| `prereg.sh` | Git, a POSIX shell, and standard utilities such as `awk`, `sed`, `diff`, and `mktemp` |
| OpenCode and Pi adapters | The runtime supplied by the harness; adapters use built-in modules |
| Version-maintenance script | Bash and `jq`, for contributors only |

The plugin does not install Python, R, solvers, or scientific packages. Pin those
in the research project's environment. On Windows the hook wrapper looks for Git
for Windows Bash, then `bash` on `PATH`; without Bash it exits without injecting
the bootstrap.

## Cursor

Use Cursor's plugin marketplace if Science Superpowers is available there, or
load a local checkout through Cursor's documented local-plugin directory:

```bash
git clone https://github.com/K-Dense-AI/science-superpowers.git
cd science-superpowers
mkdir -p "$HOME/.cursor/plugins/local"
ln -s "$(pwd -P)" "$HOME/.cursor/plugins/local/science-superpowers"
```

Run this once; if the destination already exists, inspect it before changing it.
Reload the window or restart Cursor, then check the plugin's components in
Customize. Local imports must be allowed by your workspace policy, and a
marketplace installation with the same name takes precedence over a local copy.
[Cursor's local-plugin guide](https://cursor.com/docs/plugins#test-plugins-locally)
describes this loading mechanism.

The repository's [Cursor manifest](../.cursor-plugin/plugin.json) declares both
`./skills/` and [the session hook](../hooks/hooks-cursor.json). Confirm the hook is
loaded as well as the skills, especially if your client selects the portable
manifest instead.

## Claude Code

Run these commands **inside Claude Code**:

```text
/plugin marketplace add K-Dense-AI/science-superpowers
/plugin install science-superpowers@science-superpowers-dev
```

The marketplace name is `science-superpowers-dev`, as declared in the repository's
[marketplace manifest](../.claude-plugin/marketplace.json). For a local checkout,
replace the first command's source with its absolute directory path. These are
the standard [marketplace installation commands](https://code.claude.com/docs/en/discover-plugins).

Open a new session after installation. The
[Claude Code hook configuration](../hooks/hooks.json) invokes the bootstrap for
`startup`, `clear`, and `compact` session events.

## Codex

The repository includes a [Codex plugin manifest](../.codex-plugin/plugin.json)
declaring `./skills/`. In Codex CLI, `/plugins` installs plugins from configured
marketplaces. Use a marketplace that contains this package; the presence of the
manifest does not mean it is listed in the public directory.
[OpenAI's plugin guide](https://learn.chatgpt.com/docs/plugins) describes supported
installation surfaces.

For a local checkout, native skill discovery also provides a direct setup path.
From the **research repository**, set the absolute clone path and link the skills:

```bash
SCIENCE_SUPERPOWERS_DIR="/absolute/path/to/science-superpowers"
mkdir -p .agents/skills
for skill_dir in "$SCIENCE_SUPERPOWERS_DIR"/skills/*; do
  ln -s "$skill_dir" ".agents/skills/$(basename "$skill_dir")"
done
```

Run once in a project without existing same-named skill entries. These symlinks
depend on your local clone and are not a portable team installation. Codex
supports repository `.agents/skills` directories and symlinked skill folders.
[OpenAI's skills guide](https://learn.chatgpt.com/docs/build-skills#where-codex-loads-local-skills)
documents discovery.

Start a fresh session and explicitly request:

```text
Use science-superpowers:using-science-superpowers for this session.
```

The committed Codex manifest does not declare a bootstrap hook. Verify activation
instead of assuming that installing the skills injected the bootstrap. For tool
terminology, see the [repository's Codex mapping](../skills/using-science-superpowers/references/codex-tools.md).

## Gemini CLI

From your terminal:

```bash
gemini extensions install https://github.com/K-Dense-AI/science-superpowers
gemini extensions list
```

Open a new session. The [extension manifest](../gemini-extension.json) names
`GEMINI.md` as its context file; that file imports the bootstrap and Gemini tool
mapping. See the [Gemini CLI extension guide](https://geminicli.com/docs/extensions/)
for the installation command and extension status checks.

## OpenCode, Pi, and Antigravity

These integrations have dedicated instructions maintained alongside their adapters:

| Harness | Installation entry point | Bootstrap |
| --- | --- | --- |
| [OpenCode](../.opencode/INSTALL.md) | Add the documented Git-backed package to the `plugin` array in `opencode.json` | Adapter registers the skills path and prepends bootstrap text to the first user message |
| [Pi](../.pi/INSTALL.md) | `pi install git:github.com/K-Dense-AI/science-superpowers` | Package extension appends bootstrap to the prompt through `before_agent_start` |
| [Antigravity](../.antigravity/INSTALL.md) | Install workspace skills and the supplied always-on rule | The rule carries bootstrap instructions |

Use those guides for exact configuration, tool mapping, and update instructions.
Pi's extension also displays `Science Superpowers loaded` when its bootstrap file
is available.

## Other Agent Plugins clients

The root [portable manifest](../plugin.json) declares package metadata. Skills live
at `skills/<name>/SKILL.md`. Use your client's package installation mechanism;
bootstrap hooks are client-specific. If no adapter loads the bootstrap, explicitly
request `science-superpowers:using-science-superpowers` at session start.

## Verify every installation

1. Open a fresh conversation and confirm the harness lists the installed skills.
2. Send: **“Let's analyze this dataset.”** No real dataset is needed for this check.
3. Check that the agent loads `science-superpowers:framing-research-questions`, asks
   about the question and context, and seeks framing approval before analysis.

A skill list proves discovery. The observed response checks behavior. For a
developer-level check of the Cursor hook payload, see
[contributor validation](contributing.md#validate-your-change).

## Updating

Update through the mechanism you installed with. Marketplace caches may need a
refresh or reinstall. With a local symlink, update the clone and start a fresh
session; OpenCode and Pi cache bootstrap content in memory. Copied Antigravity
rules need to be copied again after changes. If the library gains a new skill,
setups linking individual skill directories need a new link for that directory.
