# sealed-evaluator

Default-FAIL success ledger + sealed fresh-context evaluation, from Anthropic's
long-running-agents harness (github.com/anthropics/cwc-long-running-agents).

The failure it kills: **premature victory declaration** — the agent grading its
own homework. Criteria start FALSE and flip only with evidence; then a sealed
evaluator (fresh context, never saw the work, can execute but not modify)
returns `PASS` or `NEEDS_WORK` per criterion. "Plausibility is not correctness."

## Install
```bash
mkdir -p ~/.claude/skills
cp -r sealed-evaluator ~/.claude/skills/
```
Then before declaring any substantial task done: "verify this properly".
