# Omacachy assistant package

The shared source is `skills/omacachy/`: an Agent Skills package with installation,
maintenance, updates, diagnostics, known errors and recovery workflows. It has
no MCP service, credential requirement, background task or automatic shell hook.
Installing it grants no authorization to modify a machine.

## Agent entry points

| Agent | Entry point | Status |
|---|---|---|
| Codex | `AGENTS.md`, `.agents/skills/omacachy`; plugin manifest `.codex-plugin/plugin.json` | Skill format and local links validated; plugin runtime untested |
| Claude Code | `CLAUDE.md`; plugin manifest `.claude-plugin/plugin.json` | Local plugin validation; runtime workflows untested |
| GitHub Copilot | `.github/copilot-instructions.md`, `.agents/skills/omacachy` | Instructions prepared; runtime untested |
| Gemini CLI | `GEMINI.md` | Explicit instructions prepared; runtime untested |
| Other agents | Ask the agent to read `AGENTS.md` and `skills/omacachy/SKILL.md` | Manual fallback; no automatic discovery promised |

Both manifests refer to the same skill directory. `.agents/skills/omacachy` is a
relative link to it; there are no duplicated policies. Plugin loaders differ:
these compatibility manifests do not imply a universal plugin installer.
For Claude Code, from this checkout use `claude --plugin-dir .` to try the local
plugin. Avoid enabling both the plugin and a second standalone copy of its skill
in the same agent. An agent running in a cloud sandbox cannot diagnose the host
without an authorized connection to that host.

To make the standalone skill available outside the checkout, create a link in
your agent's supported personal skills directory, only if no skill with that name
already exists. This is optional and changes only agent discovery. Retain the
checkout at a stable path. Git symlink support and agent versions affect discovery;
if links are unavailable, use the explicit file-reading fallback.

Example request: “Read skills/omacachy/SKILL.md and diagnose this error without
changing the system.” For updates, ask for review first or explicitly request
installation. Neither the plugin nor the skill itself grants system privileges.

## Public versus private

Commit general workflows and reproducible, anonymized error cases. Keep actual
usernames, UUIDs, partition layout, backup paths, logs, personal preferences and
machine history in an optional local file:
`${XDG_CONFIG_HOME:-$HOME/.config}/omacachy/agent-local.md`.
Never store passwords or tokens even in that profile. Local facts must still be
checked against the current system. A private profile is not loaded unless the
agent follows the skill, and requires local filesystem access.

Before publishing, review the entire repository/history separately: validating
this package is not a secret audit of pre-existing files or Git history.

## Validation and sources

Validate `skills/omacachy` with your skill validator and run
`claude plugin validate .`. Those checks do not prove runtime loading or safe
system changes. Exercise an actual request in each agent before claiming tested
support. Check current versions of these official references when updating adapters:

- [Codex plugin packaging](https://developers.openai.com/plugins/build/plugins)
- [Claude Code manifests](https://code.claude.com/docs/en/plugins-reference)
- [Copilot Agent Skills](https://docs.github.com/en/copilot/concepts/customizations/agent-skills)
- [Gemini CLI skills](https://geminicli.com/docs/cli/skills/)
