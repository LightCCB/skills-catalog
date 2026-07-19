---
name: skill-router
description: Fixed heavyweight skill pipeline for every non-trivial task. Fires on "loadout", "/loadout", "route this", "which skills", AND fire it YOURSELF at the start of any non-trivial task. Forces the task through 13 ordered stages (caveman → memory → context → method → discipline → graph → research checkpoint → capability → reflect → adversary gate → engineering → GSD → autoreview). Research is never silently skipped — the user decides at a checkpoint.
---

# skill-router — the loadout pipeline

A fixed, heavyweight pipeline. Force every non-trivial task through the stages
IN ORDER. Skip a stage only when it objectively cannot apply (no repo → no
autoreview); say so in one clause. Token-savers stay ON at all times.

## The pipeline (in order)

1. **caveman** — FIRST. Confirm mode `full` (`/caveman full` if off). Every
   token after this, including memory narration, is compressed.
2. **logseq-brain** — load project memory. "load <project>" / recall relevant
   context before touching anything.
3. **Recent .md files** — recently modified markdown in the working repo
   (`git log --name-only -5 -- '*.md'`, `ls -t`) — handoffs, plans, CLAUDE.md,
   docs/claude-memories. Read what's relevant.
4. **fable-method** — classify the ask → define done + named verification →
   evidence plan → one recommendation → surgical act → verify by observation →
   report outcome-first.
5. **working-philosophy** — standing overlay: nothing is true until reality
   shows it. Mocks are not evidence. Trace everything.
6. **graphify** — query the knowledge graph for codebase/corpus questions
   instead of dumping files. Build/update if stale.
7. **RESEARCH CHECKPOINT — pause and ask the user.** Never silently skip or
   silently do research. Using AskUserQuestion, present:
   - 2-4 concrete research options you propose (topic + why it would change
     the outcome; multi-select), AND
   - "Research not necessary" as an explicit option.
   Execute whatever the user picks via **research-methodology** (version
   detection, official docs first), escalating to **deep-research** when the
   chosen scope needs multi-source web work. **Every claim cited — including
   claims sourced from our own memory/notes (cite the memory file, handoff,
   or session). No uncited claims.** If the user picks "not necessary",
   record that decision in one line and move on.
8. **product-capability** — feature/PRD work: capability contract
   (constraints, invariants, interfaces, open questions) before any build.
9. **reflect** — SELF-attack the plan (GATE→LOOK→RESHAPE→ATTACK→CARD) so the
   adversary faces a hardened plan. Also fires mid-work on any new
   irreversible decision.
10. **ADVERSARY GATE** — spawn an independent fresh-context subagent briefed:
    *"Disagree with everything. Attack the premise, plan, scope, evidence,
    approach. Steelman the strongest alternative. Your job is to kill this
    plan."* Argue it. Buildout blocked until it returns **CONVINCED** (with
    reasons) or the plan is revised until it survives. Max 3 rounds, then
    escalate the dispute to the user. Log objections → responses → verdict.
11. **mattpocock-skills** — engineering chain as applicable: tdd,
    diagnosing-bugs, codebase-design, domain-modeling, code-review.
12. **Get Shit Done (GSD)** — multi-phase build work via `/gsd-*`
    (discuss → plan → execute → verify → ship).
13. **autoreview** — pre-commit/ship second-model review of the diff.

## Enforcement

`bash ~/.claude/hooks/loadout-gate.sh start <session_id>` begins enforcement;
mark each finished stage with `... mark <session_id> <N>`. PreToolUse hooks
DENY Edit/Write until stages 1-4 are marked, and DENY git push / PR merge
until stages 10 (adversary CONVINCED) and 13 (autoreview) are marked.
Trivial task → `... off <session_id>`.

## Token-savers — ON AT ALL TIMES

caveman (`full`, never off unless user says "stop caveman") · rtk (bash hook) ·
cavecrew subagents (delegate search/review/small edits) · firecrawl-lean over
just-scrape · graphify over file-dumping. Standing state, not per-task choice.

## Output

One compact loadout line as stages complete:
"Loadout: caveman full · brain ✓ · md: <files> · fable → … · research: <user choice> · reflect ✓ · adversary: CONVINCED r2 · …".
Skipped stages get one clause each.
