/**
 * Science Superpowers extension for Pi (https://pi.dev)
 *
 * Injects the science-superpowers bootstrap — the `using-science-superpowers`
 * skill — into the system prompt so the methodology, especially the
 * `framing-research-questions` HARD GATE, is active from the first message,
 * before any data is touched.
 *
 * Pi discovers the skills themselves natively from this package's `skills/`
 * directory (declared in package.json under the "pi" key). This extension only
 * handles the always-on bootstrap, the same job the SessionStart shell hook
 * does for Claude Code / Cursor and the system-prompt transform does for
 * OpenCode.
 *
 * Zero runtime dependencies: the `ExtensionAPI` import is type-only (erased at
 * runtime) and everything else uses Node built-ins.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import path from "node:path";
import fs from "node:fs";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Sentinel string that marks our injected bootstrap. before_agent_start fires
// once per turn; this lets us avoid appending the bootstrap a second time.
const SENTINEL = "You have science superpowers.";

// Strip YAML frontmatter, returning just the SKILL.md body.
function stripFrontmatter(content: string): string {
  const match = content.match(/^---\n[\s\S]*?\n---\n([\s\S]*)$/);
  return match ? match[1] : content;
}

// The SKILL.md does not change mid-session, so build the bootstrap once.
// undefined = not yet built, null = source file missing.
let bootstrapCache: string | null | undefined;

function getBootstrap(): string | null {
  if (bootstrapCache !== undefined) return bootstrapCache;

  const skillPath = path.resolve(
    __dirname,
    "../../skills/using-science-superpowers/SKILL.md",
  );
  if (!fs.existsSync(skillPath)) {
    bootstrapCache = null;
    return null;
  }

  const body = stripFrontmatter(fs.readFileSync(skillPath, "utf8"));

  const toolMapping = `**Tool mapping for Pi:**
When a skill references a Claude Code tool you don't have, use the Pi equivalent:
- \`Read\` → \`read\`, \`Write\` → \`write\`, \`Edit\` → \`edit\`, \`Bash\` → \`bash\`, \`Grep\` → \`grep\`, \`Glob\` → \`find\`
- \`Skill\` tool → skills load natively; Pi exposes them as \`/skill:name\`. When a skill matches, read its SKILL.md and follow it.
- \`TodoWrite\` → Pi has no to-do tool; track the skill's checklist inline in your replies.
- \`Task\` (subagent dispatch) → Pi ships without sub-agents. Run the dispatched work inline with explicit role separation, or install a Pi package that adds sub-agents.
See \`skills/using-science-superpowers/references/pi-tools.md\` for the full mapping.`;

  bootstrapCache = `<EXTREMELY_IMPORTANT>
${SENTINEL}

**The using-science-superpowers skill content is included below. It is ALREADY LOADED — you are currently following it. Do NOT load "using-science-superpowers" again via /skill; that would be redundant. For every other skill, read its SKILL.md when it applies.**

${body}

${toolMapping}
</EXTREMELY_IMPORTANT>`;

  return bootstrapCache;
}

export default function (pi: ExtensionAPI) {
  // Confirm the bootstrap loaded — helps verify the install.
  pi.on("session_start", async (_event, ctx) => {
    if (getBootstrap()) {
      ctx.ui.notify("Science Superpowers loaded", "info");
    }
  });

  // before_agent_start fires once per turn. Pi rebuilds the system prompt each
  // turn, so appending the bootstrap every turn keeps it present without it
  // accumulating. The sentinel guard makes this safe even if a future Pi
  // version were to chain the previous turn's prompt.
  pi.on("before_agent_start", async (event) => {
    const bootstrap = getBootstrap();
    if (!bootstrap) return;
    if (event.systemPrompt.includes(SENTINEL)) return;
    return { systemPrompt: `${event.systemPrompt}\n\n${bootstrap}` };
  });
}
