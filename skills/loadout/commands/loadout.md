---
description: Run the fixed skill pipeline (brain → caveman → md files → fable-method → philosophy → graphify → research w/ citations → capability → mattpocock → GSD → reflect → autoreview).
argument-hint: <task description>
---

Use the `skill-router` skill now.

Task: $ARGUMENTS

ENFORCEMENT: first run `bash ~/.claude/hooks/loadout-gate.sh start <session_id>` (session_id from env/transcript; use "default" if unknown). After completing EACH stage, mark it: `bash ~/.claude/hooks/loadout-gate.sh mark <session_id> <N>`. Hooks DENY Edit/Write until stages 1-4 are marked, and deny git push/merge until stage 13. For a trivial task, skip enforcement (`loadout-gate off`).

Work the pipeline IN ORDER (do not cherry-pick):
1. logseq-brain — load relevant project memory.
2. caveman — ensure mode `full` (`/caveman full` if off).
3. Check recently modified .md files in the working repo; read the relevant ones.
4. fable-method — classify ask, define done + named verification.
5. working-philosophy — evidence over claims, standing discipline.
6. graphify — query the graph instead of dumping files.
7. research-methodology — version-accurate facts; EVERY claim cited, including cites back to our own memory/knowledge files.
8. deep-research — only if multi-source web research needed; same citation rule.
9. product-capability — capability contract if this is a feature/PRD.
10. mattpocock-skills — tdd / diagnosing-bugs / code-review as applicable.
11. GSD — multi-phase build work via /gsd-*.
12. reflect — attack any irreversible decision before committing.
13. autoreview — second-model review before commit/ship.

Skip a stage only if it objectively cannot apply; note the skip in one clause.
Then state the compact loadout line and proceed, caveman-terse.

If no task given: state pipeline status (savers on, brain loaded?) and ask for the task.
