---
name: skill-router
description: Fixed skill-loading pipeline for every non-trivial task. Fires on "loadout", "/loadout", "route this", "which skills", AND fire it YOURSELF at the start of any non-trivial task. Loads a mandatory ordered workflow of skills (memory → compression → context → method → discipline → graph → research w/ citations → capability → engineering → GSD → reflect → autoreview) rather than guessing which are needed.
---

# skill-router — the loadout pipeline

NOT a picker. A fixed pipeline. Work through the stages IN ORDER on every
non-trivial task. Skip a stage only when it objectively cannot apply (no repo →
no autoreview); say so in one line. Token-savers stay ON at all times.

## The pipeline (in order)

1. **logseq-brain** — load project memory first. "load <project>" / recall
   relevant context before anything else.
2. **caveman** — confirm mode `full` (run `/caveman full` if off). All output
   compressed from here on.
3. **Recent .md files** — check recently modified markdown in the working repo
   (`git log --name-only -5 -- '*.md'` + `ls -t **/*.md | head`) — handoffs,
   plans, CLAUDE.md, docs/claude-memories. Read what's relevant.
4. **fable-method** — run the loop: classify ask → define done + named
   verification → evidence → one recommendation → surgical act → verify by
   observation → report outcome-first.
5. **working-philosophy** — standing discipline: nothing is true until reality
   shows it. Mocks are not evidence; trace everything.
6. **graphify** — query the knowledge graph for codebase/corpus questions
   instead of dumping files. Build/update graph if stale.
7. **research-methodology** — for any dependency/API/domain fact: detect
   versions, prefer official docs. **Every research claim gets a citation —
   even when the source is our own prior knowledge/memory (cite the memory
   file, handoff doc, or session note). No uncited claims.**
8. **deep-research** — only if the task needs multi-source web research.
   **Same citation rule: every claim cited, including references back to our
   own knowledge base.**
9. **product-capability** — if the task is a feature/PRD/roadmap item: produce
   the capability contract (constraints, invariants, interfaces, open
   questions) before implementation.
10. **mattpocock-skills** — engineering chain as applicable: tdd,
    diagnosing-bugs, codebase-design, domain-modeling, code-review.
11. **Get Shit Done (GSD)** — multi-phase build work runs through `/gsd-*`
    (discuss → plan → execute → verify → ship).
12. **reflect** — any decision whose undo cost exceeds a bad day: run the
    attack loop before committing.
13. **autoreview** — pre-commit/ship second-model review of the diff.

## Token-savers — ON AT ALL TIMES

caveman (`full`, never off unless user says "stop caveman") · rtk (bash hook) ·
cavecrew subagents (delegate search/review/small edits) · firecrawl-lean over
just-scrape · graphify over file-dumping. Not per-task choices — standing state.

## Output

After stepping the pipeline, state one compact line per active stage:
"Loadout: brain ✓ · caveman full · md: <files> · fable-method → … · citations on".
Then proceed. Skipped stages get one clause each ("no repo → autoreview n/a").
