# Science Superpowers — Contributor Guidelines

## What this project is

Science Superpowers is a zero-dependency skills library that gives research agents a
computational-science methodology: framing questions, surveying prior work, designing
analyses, pre-registering predictions, running reproducible analyses, investigating
anomalies, verifying results, and reviewing them adversarially.

The architecture is reused from [Superpowers](https://github.com/obra/superpowers): a
session-start bootstrap hook injects `using-science-superpowers`, which makes the agent
check for and invoke relevant skills before acting. Skills are markdown files under
`skills/<name>/SKILL.md` with `name` and `description` frontmatter.

## Design principles (read before changing skills)

- **Skills shape behavior; they are not prose.** Treat skill content like code. The
  Iron Laws, Red Flags tables, rationalization tables, and "letter vs spirit" framing
  are deliberate behavior-shaping devices, not decoration.
- **Descriptions say WHEN to use, not WHAT the skill does.** Summarizing the workflow in
  the description causes agents to follow the summary instead of reading the skill.
- **Pre-registration is the central discipline**, the way TDD is central to Superpowers.
  Confirmatory and exploratory analysis must always be distinguishable.
- **"Your human partner"** is deliberate terminology. Keep it.
- **Zero third-party dependencies.** The plugin must work with only the harness and a
  POSIX shell. Domain-specific tooling belongs in a separate plugin.

## Working on skills

- Use `skills/writing-science-skills/SKILL.md` — it adapts RED-GREEN-REFACTOR to skill
  authoring. No skill change without a failing test (a pressure scenario) first.
- Keep skills technology-agnostic where possible; when a skill is specific to a language
  or library, make that explicit in its triggers.
- Run `scripts/bump-version.sh --check` after touching any manifest to confirm versions
  stay in sync across all harnesses.

## General

- One problem per change.
- Cross-reference other skills as `science-superpowers:<skill-name>`, never with `@`
  links (which force-load and burn context).
- Test on at least one harness (the Cursor `sessionStart` hook is the easiest to verify).
