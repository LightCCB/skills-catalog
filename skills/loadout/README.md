# loadout — skill router

A tiny meta-skill: before any non-trivial task, it scans your skill arsenal,
shortlists the 1-5 skills that actually help, and keeps your token-savers on.
Stops the agent guessing across a large skill collection and bloating context.

## Install (Claude Code)

**Manual (works everywhere):**
```bash
# from a clone of this repo
cp -R skills/loadout ~/.claude/skills/loadout
cp skills/loadout/commands/loadout.md ~/.claude/commands/loadout.md
```
Global (`~/.claude/…`) = all projects. Or use a project's `.claude/…` to scope it.

**Then customize:** edit `~/.claude/skills/loadout/references/arsenal.md`
(renamed from `arsenal-template.md`) — list YOUR installed skills, grouped by
domain, and your token-saving skills under "Token-savers".

```bash
mv ~/.claude/skills/loadout/references/arsenal-template.md \
   ~/.claude/skills/loadout/references/arsenal.md
```

## Use
- `/loadout <task>` — route a task now.
- Or just start work — the skill fires itself on non-trivial tasks.

## Why
Every loaded skill is context (token) cost. Precision beats coverage. The router
turns "which of my 100 skills apply?" into a 10-second scan + a named shortlist,
and enforces that your token-reducing skills stay on.

MIT.
