# loadout — a heavyweight, enforced skill pipeline for Claude Code

`/loadout <task>` forces Claude through a **fixed, ordered 13-stage pipeline**
before and during any non-trivial task — memory first, compressed output
always, cited research the **user** green-lights, a self-attack, an
independent **adversary agent that must be convinced before buildout**, and
review gates. Hooks hard-enforce the order: edits are denied until the early
stages complete, pushes are denied until the adversary is convinced and
review has run.

## The pipeline

1. **[caveman](https://github.com/JuliusBrussee/caveman)** — compressed output first; everything after is terse
2. **[logseq-brain](https://github.com/jame581/skillsmith)** — load project memory
3. **Recent .md files** — read fresh handoffs/plans/docs in the repo (plain git/ls)
4. **[fable-method](https://github.com/Sahir619/fable-method)** — classify ask, define done + named verification
5. **[working-philosophy](../working-philosophy)** — nothing is true until reality shows it *(ours — distilled from [sylweriusz/implication-machine](https://github.com/sylweriusz/implication-machine/blob/main/docs/zen-of-creativity-explained.md))*
6. **[graphify](https://github.com/Graphify-Labs/graphify)** — query the knowledge graph, don't dump files
7. **RESEARCH CHECKPOINT** — Claude pauses and asks: 2-4 proposed research
   topics (with why) + an explicit "research not necessary" option. The user
   decides. Picks run via **[research-methodology](../research-methodology)**
   *(ours — extracted from [VAMFI/claude-user-memory](https://github.com/VAMFI/claude-user-memory))*,
   escalating to **[deep-research](https://github.com/affaan-m/ECC)** for
   multi-source work. **Every claim cited — even citations back to your own
   memory/notes.** Research is never silently skipped or silently done.
8. **[product-capability](https://github.com/affaan-m/ECC)** — capability contract for feature/PRD work
9. **[reflect](https://github.com/seldonframe/reflect)** — self-attack the plan so the adversary faces a hardened one
10. **Adversary gate** — an independent contrarian subagent briefed to kill
    the plan; **no buildout until it returns CONVINCED** (max 3 rounds, then
    the dispute goes to the user) *(built into this skill)*
11. **[mattpocock-skills](https://github.com/mattpocock/skills)** — tdd / diagnosing-bugs / code-review
12. **[GSD](https://github.com/open-gsd/gsd-core)** — multi-phase builds via `/gsd-*`
13. **[autoreview](https://github.com/openclaw/openclaw)** — second-model review before ship

## Install — let Claude do it

Paste this into Claude Code:

> Clone https://github.com/LightCCB/skills-catalog to a temp dir, run
> `bash skills/loadout/install.sh`, then follow its final printed step
> (add the PreToolUse hook to `~/.claude/settings.json`) and restart.

Or by hand:

```bash
git clone --depth 1 https://github.com/LightCCB/skills-catalog /tmp/sc
bash /tmp/sc/skills/loadout/install.sh
```

The installer copies the skill + `/loadout` command + enforcement hooks,
installs the bundled skills (`working-philosophy`, `research-methodology`),
and pulls plugin deps (fable-method, reflect, caveman, mattpocock-skills,
logseq-brain) via the `claude` CLI plus folder deps (product-capability,
autoreview) via `npx skills`. It never edits `settings.json` itself — it
prints the hook snippet for you to add (one manual paste + restart).

Still manual: [graphify](https://github.com/Graphify-Labs/graphify) and
[GSD](https://github.com/open-gsd/gsd-core) (GSD has its own installer:
`npx @opengsd/gsd-core`). Missing deps are skipped with a note at runtime.

## Enforcement

`hooks/loadout-gate.sh` tracks per-session stage state;
`hooks/loadout-enforce.sh` (PreToolUse) **denies** Edit/Write until stages
1-4 are marked and denies `git push` / PR merge until stage 10 (adversary
CONVINCED) and stage 13 (autoreview) are marked. Trivial tasks:
`loadout-gate.sh off <session>`.

MIT. Skills belong to their respective authors.
