---
description: Force the task through the 13-stage heavyweight pipeline (caveman → brain → md → fable-method → philosophy → graphify → RESEARCH CHECKPOINT (user decides) → capability → reflect → adversary gate → mattpocock → GSD → autoreview).
argument-hint: <task description>
---

Use the `skill-router` skill now.

Task: $ARGUMENTS

ENFORCEMENT: run `bash ~/.claude/hooks/loadout-gate.sh start <session_id>` ("default" if unknown). Mark each finished stage: `bash ~/.claude/hooks/loadout-gate.sh mark <session_id> <N>`. Hooks DENY Edit/Write until stages 1-4, and DENY git push/merge until stages 10 (adversary CONVINCED) + 13 (autoreview). Trivial task → `loadout-gate off`.

Force the pipeline IN ORDER (no cherry-picking):
1. caveman — mode `full` first; everything after is compressed.
2. logseq-brain — load relevant project memory.
3. Recent .md files — read fresh handoffs/plans/docs in the repo.
4. fable-method — classify ask, define done + named verification.
5. working-philosophy — evidence over claims (standing overlay).
6. graphify — query the graph, don't dump files.
7. RESEARCH CHECKPOINT — PAUSE. AskUserQuestion with 2-4 proposed research options (topic + why, multi-select) PLUS "Research not necessary". Execute the user's picks via research-methodology, escalate to deep-research if scope demands. EVERY claim cited, incl. cites to our own memory/notes. Never silently skip, never silently research.
8. product-capability — capability contract if feature/PRD.
9. reflect — self-attack the plan BEFORE the adversary sees it.
10. ADVERSARY GATE — independent contrarian subagent must return CONVINCED (max 3 rounds, then escalate to user). No buildout before verdict.
11. mattpocock-skills — tdd / diagnosing-bugs / code-review as applicable.
12. GSD — multi-phase build via /gsd-*.
13. autoreview — second-model review before commit/ship.

Skip only what objectively cannot apply; one clause per skip. State the compact loadout line as you go, caveman-terse.

If no task given: report pipeline status (savers, brain, gate state) and ask for the task.
