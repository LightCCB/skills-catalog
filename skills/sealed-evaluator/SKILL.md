---
name: sealed-evaluator
description: Default-FAIL success ledger + sealed fresh-context evaluation, from Anthropic's long-running-agents harness. Use before declaring ANY substantial multi-step task done, when the user asks "is it actually done/working", "verify this properly", "don't trust your own claim", for long-horizon or unsupervised work, and whenever a task's success criteria could be gamed by the agent grading its own homework. Creates a criteria ledger where everything starts FALSE and only flips with evidence, then spawns a sealed evaluator subagent (fresh context, never saw the work, cannot write) that returns PASS or NEEDS_WORK per criterion.
---

# sealed-evaluator — Default-FAIL ledger + sealed judge

Two coupled patterns from Anthropic's long-running-agent harness
(`github.com/anthropics/cwc-long-running-agents` + the engineering post
"Effective harnesses for long-running agents"). The failure they kill:
**premature victory declaration** — an agent announcing done because the work
*looks* done in its own narrative. Doctrine, verbatim from the harness:
**"Plausibility is not correctness."**

How this composes with the existing arsenal (do not duplicate them):
fable-method defines done and plans evidence — this skill gives that "done" a
**machine-checkable ledger** and a **sealed second opinion**. fable-judge
re-verifies *in-thread* (it sees the conversation); autoreview reviews *diffs*.
The sealed evaluator sees neither the conversation nor the narrative — only the
criteria and the artifacts. Use it as the last gate before "done", before/with
autoreview at ship time. For multi-phase project structure use GSD; this skill
deliberately owns NO session-state or decomposition machinery.

## Part 1 — the Default-FAIL ledger

At task start (after "done" is defined), write the criteria file:

- **JSON, not markdown** — the harness chose JSON because "the model is less
  likely to inappropriately change or overwrite JSON files."
- Default name `test-results.json` in the task's working dir (any name works;
  tell the evaluator where it is).
- Shape (harness `feature_list.json` style):

```json
{
  "criterion-slug": {
    "description": "What must be true, phrased so a stranger can check it",
    "steps": ["How to check it, step by step, as a human user would"],
    "passes": false,
    "evidence": ""
  }
}
```

Rules:
1. **Every criterion starts `passes: false`.** No exceptions — including the
   "easy" ones. The task cannot be declared done while any criterion is false.
2. **A flip requires evidence in the same edit**: the exact command + output,
   test result, screenshot path, or `file:line` that proves it. No evidence
   string → the flip is invalid. (The harness enforces this with a
   PreToolUse hook chain — evidence must be *Read* in-session before the
   results file may be written. We enforce it by discipline + the evaluator
   re-checking; add the hooks for unsupervised runs.)
3. **Criteria are append-only during the task.** Removing or weakening a
   criterion mid-task is the failure mode the pattern exists to prevent
   ("It is unacceptable to remove or edit tests"). If a criterion was genuinely
   wrong, mark it `"waived": "<reason>"` and leave it visible.
4. The final report to the user **shows the ledger** — including anything
   waived or still false.

## Part 2 — the sealed evaluator

When all criteria read `passes: true` (or the user asks for verification),
spawn the evaluator via the Agent tool (`general-purpose`), using
[agents/evaluator.md](agents/evaluator.md) as the prompt template. The seal:

- **Fresh context** — subagents receive only their prompt, never this
  conversation. The evaluator has not seen the work happen, only its outputs.
- **Give it only**: the ledger path, the artifact locations (repo dir, screenshots,
  logs), and the template's instructions. Do NOT summarize what you built,
  how hard it was, or what you believe works — that narrative is the
  contamination the seal exists to exclude.
- **Tool contract (explicit, because "read-only" is not enforceable with
  Bash):** the evaluator MAY execute — run the tests, run the build, `git diff`,
  open screenshots — and MUST NOT modify: no Write/Edit tools, and its
  instructions forbid mutating commands. Execution is required (a judge that
  can't re-run the tests is weaker than no judge); mutation is forbidden.
- **Output contract (machine-parseable):** line 1 is exactly `PASS` or
  `NEEDS_WORK`. PASS → one line of the single most convincing evidence.
  NEEDS_WORK → bullet list of specific, fixable findings per failed criterion.
- **On NEEDS_WORK**: the findings become the next work cycle's starting input.
  Fix, re-flip with new evidence, re-evaluate. Do not argue with the evaluator
  in-thread — it can't hear you, and that's the point.

## When NOT to use this

- Trivial or single-step tasks — the ledger is overhead with no gaming risk.
- Pure judgment/writing tasks with no checkable criteria — use fable-judge.
- Simple well-scoped bug fixes — a fixed localize→repair→validate pipeline
  often beats agentic machinery entirely (Agentless, arxiv 2407.01489);
  match complexity to the task before reaching for any harness.

## Unsupervised / long-running use

For overnight or looped runs, pair the ledger with the harness's operator
controls (kill-switch file, steering file, commit-on-stop) and evidence-gate
hooks — see the repo. This skill's scope is the supervised session: ledger +
sealed verdict. Sources: repo README/agents/evaluator.md/hooks;
anthropic.com/engineering/effective-harnesses-for-long-running-agents.
