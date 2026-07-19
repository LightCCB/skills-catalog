# loadout — a fixed skill-loading pipeline for Claude Code

`/loadout <task>` steps Claude through a **mandatory, ordered pipeline** of
skills before it starts working — memory first, compression always, method,
discipline, research with citations, then review gates. Not a picker: the
order IS the workflow.

## The pipeline

1. **[logseq-brain](https://github.com/jame581/skillsmith)** — load project memory
2. **[caveman](https://github.com/JuliusBrussee/caveman)** — compressed output, always on (`full`)
3. **Recent .md files** — read fresh handoffs/plans/docs in the repo (no skill; plain git/ls)
4. **[fable-method](https://github.com/Sahir619/fable-method)** — classify ask, define done + named verification
5. **[working-philosophy](../working-philosophy)** — nothing is true until reality shows it *(ours — distilled from [sylweriusz/implication-machine](https://github.com/sylweriusz/implication-machine/blob/main/docs/zen-of-creativity-explained.md))*
6. **[graphify](https://github.com/Graphify-Labs/graphify)** — query the knowledge graph, don't dump files
7. **[research-methodology](../research-methodology)** — version-accurate facts; **every claim cited, even
   cites back to your own memory/notes** *(ours — extracted from [VAMFI/claude-user-memory](https://github.com/VAMFI/claude-user-memory))*
8. **[deep-research](https://github.com/affaan-m/ECC)** — only when multi-source web research is needed (same
   citation rule; Claude Code's built-in deep-research also satisfies this stage)
9. **[product-capability](https://github.com/affaan-m/ECC)** — capability contract for feature/PRD work
10. **adversary gate** — an independent contrarian subagent briefed to
    disagree with everything; no buildout until it returns CONVINCED *(built into this skill — see SKILL.md stage 10)*
11. **[mattpocock-skills](https://github.com/mattpocock/skills)** — tdd / diagnosing-bugs / code-review
12. **[GSD](https://github.com/open-gsd/gsd-core)** — multi-phase builds via `/gsd-*`
13. **[reflect](https://github.com/seldonframe/reflect)** — attack irreversible decisions before committing
14. **[autoreview](https://github.com/openclaw/openclaw)** — second-model review before ship

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
each pipeline stage above links to its source. `working-philosophy` and
`research-methodology` live in this repo (`skills/`). Missing ones are
skipped with a note — install what you use.

MIT. Skills belong to their respective authors.
