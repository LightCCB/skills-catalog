---
name: working-philosophy
description: Standing build discipline — nothing is true until reality shows it. Use continuously while building, verifying, or shipping anything: when deciding whether something is "done", designing verification, handling a failure, sizing an increment, granting a capability/permission, writing an audit trail, or updating docs/contract. Fires on "is this done", "how should I verify this", "is this safe to allow", "why did it fail", "should I mock this", "what should the contract say", or as background discipline on any multi-step build. Complements reflect (which handles one-off decisions); this governs how the work itself is done.
---

# Working Philosophy — evidence over claims

One rule: **nothing is true until reality shows it.** "Done" is a claim.
"Correct" is a claim. "Allowed" is a claim. No claim counts without evidence
you can reconstruct.

Full source: `references/working-philosophy-full.md`
(from [sylweriusz/implication-machine](https://github.com/sylweriusz/implication-machine/blob/main/docs/zen-of-creativity-explained.md)).

## Two axes, one loop

A system that acts in the world raises two independent questions. Run the same
loop on each:

| Axis | Intent | Check against reality | Signal of the gap |
|---|---|---|---|
| **Correctness** — does it do what it should? | Contract (§1) | Verification (§2) | Failure (§3) |
| **Authority** — what may it do, and what did it do? | Capability model (§5) | Audit (§6) | Violation (§3 on authority) |

Correct-but-over-privileged is still dangerous. Sandboxed-but-wrong is still
wrong. Both axes write to and read from **one shared artifact: the trace**.

- Correctness axis: §1–4, §7–10, §12
- Authority axis: §5, §6, §11

## The 12 principles (rule of each)

1. **Living Contract** — one source of truth that *grows from evidence*, not a
   plan written up front. Two phases, never simultaneous: evidence → contract
   (authoring), then contract → implementation (governing).
2. **Real Verification** — a check that can silently pass while the real thing
   is broken is worse than no check. A failing real test beats a passing mock:
   the failure is knowledge, the pass is not. Mocks are dev aids, never evidence.
3. **Failure as Signal** — never weaken a verification to make it pass, never
   suppress a failure to go green. Green means *verified working*. Classify each
   failure: does it correct the implementation, or enrich the contract?
4. **Incremental Delivery** — if you can't explain what an increment does and
   why it's complete, it's too big. Split it.
5. **Capability Model (safety by default)** — if an operation can affect things
   outside the current scope, it is **not** enabled by default. Someone says
   "yes, this power, now." Revocable.
6. **Observability (audit trail)** — if you can't reconstruct what happened from
   the trace alone, the trace is insufficient. If you can't explain why a
   privileged action was taken, it shouldn't have been taken. A silently
   alterable trace proves nothing.
7. **Documentation as Working Artifact** — changed behavior + stale docs = not
   done. Docs describing behavior that doesn't exist are bugs.
8. **Reference Study (not copying)** — study for perspective. If you can't
   explain why a reference works in *their* context and whether it holds in
   yours, you're not ready to apply it.
9. **Version Control as Knowledge Base** — if the reasoning behind a change
   can't be reconstructed from the commit message + diff alone, the message is
   insufficient.
10. **Continuous Feedback** — a loop longer than your attention span guarantees
    a context-switch and a lost thread. Match cadence to human attention.
11. **No Hidden Side Effects** — a side effect invisible to the user is a bug
    even if the code is "correct". An action invisible to the trace is
    indistinguishable from one that never happened.
12. **Contract-Driven Evolution** — the contract catches drift between intent
    and reality. Let it atrophy and debt goes invisible.

## How to apply

- Before claiming done → demand evidence (§2), not a green mock.
- On a failure → classify it (§3): implementation bug, or contract was wrong?
- Before enabling anything privileged → is it off by default and revocable (§5)?
  Is it in the trace (§6, §11)?
- After behavior changes → contract + docs updated (§1, §7, §12).
- Increment feels fuzzy → too big (§4).

## Pairs with `reflect`

Different altitudes — use both:
- **reflect** fires at a *decision moment* ("rewrite or patch? ship or not?") and
  attacks the answer before you see it.
- **working-philosophy** is the *standing discipline* for how the work gets
  built, verified, and shipped after that decision.

reflect decides; this governs execution. Cite these principles inside reflect's
ATTACK step when a decision leans on "it's done" / "it's verified" / "it's
allowed" — those are exactly the claims this rule set refuses without evidence.
