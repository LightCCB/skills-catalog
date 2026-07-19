# loadout — a fixed skill-loading pipeline for Claude Code

`/loadout <task>` steps Claude through a **mandatory, ordered pipeline** of
skills before it starts working — memory first, compression always, method,
discipline, research with citations, then review gates. Not a picker: the
order IS the workflow.

## The pipeline

1. **logseq-brain** — load project memory
2. **caveman** — compressed output, always on (`full`)
3. **Recent .md files** — read fresh handoffs/plans/docs in the repo
4. **fable-method** — classify ask, define done + named verification
5. **working-philosophy** — nothing is true until reality shows it
6. **graphify** — query the knowledge graph, don't dump files
7. **research-methodology** — version-accurate facts; **every claim cited, even
   cites back to your own memory/notes**
8. **deep-research** — only when multi-source web research is needed (same
   citation rule)
9. **product-capability** — capability contract for feature/PRD work
10. **adversary gate** — an independent contrarian subagent briefed to
    disagree with everything; no buildout until it returns CONVINCED
11. **mattpocock-skills** — tdd / diagnosing-bugs / code-review
12. **GSD** — multi-phase builds via `/gsd-*`
13. **reflect** — attack irreversible decisions before committing
14. **autoreview** — second-model review before ship

Stages that objectively can't apply are skipped with a one-line note.

## Install

```bash
git clone --depth 1 https://github.com/LightCCB/skills-catalog /tmp/sc
cp -r /tmp/sc/skills/loadout ~/.claude/skills/skill-router
cp /tmp/sc/skills/loadout/commands/loadout.md ~/.claude/commands/loadout.md
```

Or per-project: copy into `.claude/skills/` + `.claude/commands/` of a repo.

## Dependencies

The pipeline references skills you install separately (each is on the
[field guide](https://skills-catalog-seven.vercel.app) with its source):
logseq-brain, caveman, fable-method, working-philosophy, graphify,
research-methodology, product-capability, mattpocock-skills, GSD, reflect,
autoreview. Missing ones are skipped with a note — install what you use.

MIT. Skills belong to their respective authors.
