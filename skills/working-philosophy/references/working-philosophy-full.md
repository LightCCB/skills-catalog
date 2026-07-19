# Working Philosophy

A project-agnostic framework for building things with discipline, evidence, and safety.

Extracted from real practice. Transferable to any project type: software, hardware, writing, design, service architecture.

---

## The Shape of the Discipline

Everything below is one discipline with one rule: **nothing is true until reality shows it.** "Done" is a claim, "correct" is a claim, "allowed" is a claim — and no claim counts without evidence you can reconstruct.

That single rule runs along **two axes**, because a system that acts in the world raises two independent questions:

- **Correctness** — *does it do what it should?*
- **Authority** — *what is it allowed to do, and what did it actually do?*

A perfectly verified system can still be dangerous (correct but over-privileged). A perfectly sandboxed system can still be wrong. The axes are orthogonal, so each needs its own loop. But it is the **same loop**, run twice:

| Axis | Intent | Check against reality | Signal of the gap |
|------|--------|-----------------------|-------------------|
| **Correctness** | Contract (§1) | Verification (§2) | Failure (§3) |
| **Authority** | Capability model (§5) | Audit (§6) | Violation / unjustified escalation (§3, applied to authority) |

The principles group accordingly. **Correctness axis:** §1–4, §7–10, §12. **Authority axis:** §5, §6, §11. They are not two subjects bolted together. The authority principles are the construction discipline re-applied to what the system is permitted to do: a capability model is a *contract of permissions*, an audit is *verification of authority*, a violation is a *failure on the authority axis*.

Both axes write to and read from **one shared artifact: the trace** (§6, §11). "Did it work?" and "what was it allowed to do, and what did it do?" are two queries against the same record. This is why the safety material is not separable without breaking something — the evidence of correctness and the evidence of authority are the same evidence.

---

## 1. Living Contract

Every project has a **single source of truth** that grows as understanding grows. Not README. Not comments. Not tribal knowledge. A dedicated artifact that starts vague and becomes sharper as the project develops.

The contract begins minimal. As work proceeds, new elements, new requirements, and new understanding of what's essential emerge. Each discovery enriches the contract. The contract does not predate the work; it grows from the work.

The contract is:
- **Organic** — starts minimal, grows as understanding emerges.
- **Atomic** — one capability at a time, once it's been recognized.
- **Living** — updated continuously, never frozen. Each revision is an enrichment, not an invalidation.
- **Evidence-anchored** — each item exists because experience showed it matters, not because someone guessed in advance.

The contract is **not** a project plan. Plans describe when. The contract describes what the thing **is becoming**.

### Two phases, never simultaneous

The contract has two relationships with the work, and they happen at different points in the loop — never at the same instant:

- **Authoring phase** (after an iteration): evidence flows *into* the contract. A signal from reality enriches or corrects a contract item. Here **evidence → contract**.
- **Governing phase** (between authorings): the current contract is binding on the implementation. Here **contract → implementation**.

Because these never co-occur, "the contract grows from evidence" and "the contract wins over the implementation" (§12) are not in tension. They are different phases of one loop — the structure of a setpoint in feedback control: the setpoint governs *now*; the outer loop adjusts it from measured error. The decision of which phase an incoming signal belongs to is made by the classify step (§3).

### Rule

Nothing is marked "done" without evidence that it works in reality. Evidence doesn't just check the contract — it **grows** the contract. If verification reveals something you didn't know, that new understanding belongs in the contract.

---

## 2. Real Verification

**Verify the real thing. It's the only way to learn something new.**

When you verify something, verify the real thing:
- Real dependencies (or a real substitute of equal fidelity).
- Real inputs from the real environment.
- Real outputs inspected, not inferred.

If a dependency is unavailable, the test **fails and explains what's missing**. It does not skip, degrade, or substitute a weaker check.

### Why

Verification has two purposes: confirming what you already know, and discovering what you don't. Mocks serve the first purpose only — they confirm your assumptions. Real verification serves both — it can show you something you didn't expect. That unexpected result is where new understanding comes from, and new understanding is what grows the contract (§1).

A mock that passes tells you your model of the world is consistent. A real test that fails tells you your model is wrong. Only the second kind of result advances the project.

### On mocks

Mocking is always suspicious. It is easy to fall into two traps:
- **False confirmation** — the mock passes because it encodes your assumptions, not because the system works.
- **Premature closure** — the mock passes, so you stop verifying. The real thing was never checked.

Mocking is cheapest when you have prior solid understanding of the dependency (you've seen it work, you know its contract) or when the fact being mocked is obvious (a pure function, a well-defined data transform). Mocking is most dangerous when you're mocking something you haven't observed yet — you're encoding ignorance as a test double.

For large projects where testing costs grow exponentially, a synthesis is necessary:
- **Mocks as development tool** — use them to iterate fast during coding. They buy speed. (Inner loop.)
- **Real verification as evidence** — at defined gates (commit, integration, release), the changed scope must be verified against reality. This is the only evidence that counts. (Outer loop.)

The longer you defer real verification, the more assumptions accumulate in the mock, the further it drifts from reality, and the more the eventual fix costs. Unverified mocks are technical debt disguised as test coverage.

### Practical tiers

1. **Deterministic check** — the smallest thing that proves a unit of behavior works. No external deps needed. Runs fast.
2. **Integration check** — real deps, real data flow, real side effects (in a bounded test environment). Runs slower, catches contract violations.
3. **Full-scope check** — everything assembled, the real thing running as it would for the user. Slowest, catches everything the first two miss.

All three tiers are required at different points. Fast checks for iteration. Full-scope checks before shipping. The mistake is treating tier 1 as sufficient for tier 3's job.

Verification results are written to the trace (§6): the same record that proves correctness also records what the run touched, which is the evidence the authority axis reads.

### Rule

At evidence-verification gates (commit, integration, release): a verification path that can silently succeed when the real thing is broken is worse than no verification at all. It gives false confidence. But even a failing real test is more valuable than a passing mock — the failure is knowledge, the pass is not.

During iteration: mocks that buy speed are acceptable, but they are not evidence. Mark them clearly as development aids, not as proof.

---

## 3. Failure as Signal

**Every failure is product evidence.** Not a reason to mock around it, not a flaky test to suppress, not a known issue to file and forget.

When something fails:
1. **Diagnose root cause** — not symptom, not proximate cause.
2. **Classify** — bug, missing feature, wrong assumption, ambiguous contract, environment issue.
3. **Fix the product** (or the contract), not the test.
4. **Record** — what failed, why, what fixed it. This becomes institutional knowledge.

### The classify step is the arbiter

Step 2 is where the loop decides *which phase* a signal belongs to (§1). A signal that says "reality disagrees with the contract" is routed one of two ways:

- **The contract item was wrong or incomplete** → the signal *grows* the contract (authoring phase, §1; evidence → contract).
- **The implementation diverged from a sound contract item** → the implementation is the bug (governing phase, §12; contract → implementation).

So classification is not only bug triage. It is the **promotion gate** that decides when an observation becomes a binding contract item — and it is what makes §12's "contract wins" a rebuttable default rather than an absolute.

The same gate works on the authority axis. A capability violation (§5, §6) is classified either as "the policy was too tight and the operation was legitimately needed" (grow the permission contract, §5) or "the system overstepped a sound policy" (the action is the bug).

### Rule

At evidence-verification gates: never weaken a verification to make it pass. Never suppress a failure to make the build green. Green means "verified working." If it's not verified, it's not green.

During iteration: a failing mock is still information — but it's information about your model, not about reality. Don't confuse the two.

---

## 4. Incremental Delivery

Work in **small, reviewable, complete increments**. Each increment:
- Has a clear scope.
- Passes all relevant verification.
- Is committable (even if not shipped).
- Doesn't break what was working before.

### Cadence

- **During iteration:** fast checks only. Ship speed matters.
- **Before integrating:** relevant integration checks.
- **Before releasing:** full-scope verification.

The cadence is not about ceremony — it's about matching verification effort to blast radius. A typo fix in a comment needs less verification than a new network protocol. Both need *some*.

### Rule

If you can't explain what an increment does and why it's complete, it's too big. Split it.

---

## 5. Capability Model (Safety by Default)

**Safe by default, powerful by consent.** This is the **authority axis's contract — the mirror of §1.** Where the Living Contract says what the system *should do*, the capability model says what it is *allowed to do*. It evolves the same way: it starts minimal, grows as you discover the authority a task actually needs (evidence-anchored, not guessed in advance), and runs the same two phases — it grows from evidence in the authoring phase and governs at runtime in the governing phase.

Not everything the system can do should be enabled by default. Distinguish between:
- **Safe operations** — bounded, reversible, contained. Can run freely.
- **Privileged operations** — affect broader scope, harder to undo, external side effects. Require explicit consent.

The consent model is not binary. It has levels:
1. **Implicit** — safe ops, no prompt needed.
2. **Per-invocation** — flag-based pre-approval for one run.
3. **Interactive** — prompt before each privileged action.
4. **Blocked** — never allowed, regardless of consent (secrets, destructive irreversible actions without rollback).

### Revocation (the mirror of §12.3)

Permissions retire the way behaviors do. A capability that is no longer needed is **removed from the policy and from the audit expectations** (§6), not left dormant. A standing permission that no one revokes is the authority-axis equivalent of dead code: invisible blast radius. Granting is evidence-anchored; revoking is too — when the evidence for a permission's necessity is gone, the permission goes.

### Why

Small models, tired humans, and automated agents all make mistakes. The blast radius of a mistake should be bounded by default. Escalation is a feature, not a bypass.

### Rule

If an operation can affect things outside the current work scope, it should not be enabled by default. The user (or operator) should explicitly say "yes, I want this power right now."

---

## 6. Observability (Audit Trail)

**Every significant action leaves a trace.** This is **verification on the authority axis — the mirror of §2.** The audit answers "what did the system actually do, and did it stay inside its permissions?" the way verification answers "does it do what the contract says?". The component that checks each privileged action against the capability model (§5) and records it is, in security terms, a **reference monitor**: it mediates every access (complete mediation), it cannot be bypassed, and it is itself inspectable.

The trace is **one artifact serving both axes**. The correctness verification (§2) and the authority audit write to and read from the same record. "Did it work?" and "what did it touch?" are two queries against it.

What gets traced:
- Tool/operation calls with inputs and results.
- Capability escalations (who asked, what was granted/denied, why).
- State changes (what was modified, by whom, when).
- Failures and recoveries.

The trace is:
- **Structured** — queryable, filterable, parseable.
- **Scoped and minimal** — per session / per run / per task, recording the least data needed to reconstruct what happened. A trace that hoards more than it needs is itself a liability — an attack surface and a retention cost — so minimality is a property, not an afterthought.
- **Inspectable** — the user can read it, not just the system.
- **Tamper-resistant** — append-only and integrity-checked. This is the mirror of §2's rule: a verification path that can silently succeed when the real thing is broken is worthless, and a trace that can be silently altered is the same false confidence on the authority axis. If the trace's integrity can't be established, it is not evidence.

### Rule

If you can't reconstruct what happened from the trace alone, the trace is insufficient. If you can't explain why a privileged action was taken, it shouldn't have been taken. If the trace can be silently altered, it proves nothing.

---

## 7. Documentation as Working Artifact

**Documentation is not after-the-fact annotation. It's a working tool that shapes how work is done.**

- For each increment: define what it should do (contract item) before writing the code for that increment. The overall contract emerges across increments; the increment's scope is defined before its implementation.
- The same holds on the authority axis: the permission a privileged operation needs is defined before the operation is enabled (§5), not discovered after it has already acted.
- Write the test plan before writing the tests.
- Record decisions with context, not just outcomes.
- Update docs when reality diverges from the spec.

Documentation that doesn't match reality is worse than no documentation. It misleads.

### Rule

If you changed the behavior and didn't update the docs, the job isn't done. If the docs describe behavior that doesn't exist, the docs are bugs.

---

## 8. Reference Study (Not Copying)

**When stuck, look at how others solved the same class of problem.** Study reference implementations, related work, prior art.

But:
- **Extract patterns, not code.** The architecture that solved a similar problem in a different context is valuable. The literal implementation may not transfer.
- **Understand why, not just what.** A pattern chosen for one constraint set may be wrong for yours.
- **Credit the source.** Influence should be visible, not hidden.

### Rule

Reference study is for perspective, not for copying. If you can't explain why a reference's approach works for their context and whether it works for yours, you're not ready to apply it.

---

## 9. Version Control as Knowledge Base

**Git history is not just a backup. It's the project's memory.**

- Commit messages describe **what changed and why**, not just "fix bug."
- Commits are **atomic and complete** — each one represents a coherent unit of work.
- History is **readable as a narrative** — you can follow the project's evolution by reading commits.
- Divergence is **never silently resolved** — it's surfaced and decided.

### Rule

If you can't reconstruct the reasoning behind a change from the commit message and the diff alone, the commit message is insufficient.

---

## 10. Continuous Feedback

**The loop between "I changed something" and "I know if it works" should be as short as possible.**

- Fast checks run automatically (on save, on commit, on push).
- Slower checks run at integration and release gates.
- Feedback is **immediate and actionable** — not a report you read next week.

The goal is not to run every check on every change. The goal is to know, as quickly as possible, whether your change broke something.

### Rule

If the feedback loop is longer than your attention span, you'll context-switch and lose the thread. Design the verification cadence to match human attention, not just system architecture.

---

## 11. No Hidden Side Effects

**If the system does something, the user should know.** This is the **completeness guarantee for the trace — the authority-axis analog of §2's "no verification that silently succeeds."** An action the audit (§6) cannot see is a gap in the evidence, so coverage must be total.

- Network calls, file system changes, process spawning — all visible.
- Escalation paths (sandbox → host → network) are explicit, not implicit.
- Audit logs show what happened, not just what was intended.

### Rule

A side effect that's invisible to the user is a bug, even if the code works as written. Transparency is a correctness property. An action invisible to the trace is indistinguishable from one that never happened — the same false confidence §2 and §6 forbid.

---

## 12. Contract-Driven Evolution

The contract evolves with the project, on both axes:

1. **New capability → new contract item → new verification.** (Correctness axis.) **New permission needed → new policy item → new audit expectation.** (Authority axis, §5/§6.) No capability is "done" until the contract says what it does and the verification proves it works.
2. **Changed behavior → updated contract → updated verification.** If the contract and the implementation disagree, the contract wins (and the implementation is a bug) — **but this is the default verdict of the governing phase, not an absolute.** The classify step (§3) can overturn it: when the evidence shows the *contract item itself* was wrong, the disagreement is resolved by growing the contract (authoring phase, §1), not by fixing the implementation.
3. **Retired capability → removed contract item → removed verification.** **Retired permission → revoked policy item → removed audit expectation** (§5). Dead code, dead specs, and standing-but-unneeded permissions are all liabilities.

### Rule

The contract catches drift between intent and reality. Let it atrophy and the project accumulates invisible debt.

---

## Summary Table

| Principle | One Sentence |
|-----------|-------------|
| Living Contract | A single source of truth that grows from evidence (authoring phase) and governs the implementation (governing phase) — two phases of one loop. |
| Real Verification | Verify the real thing at gates — it's the only way to learn something new. Mocks buy speed in the inner loop, not evidence. |
| Failure as Signal | Every failure is evidence; the classify step routes it to grow-the-contract or fix-the-implementation. Fix the product, not the test. |
| Incremental Delivery | Small, complete, reviewable units. Match verification to blast radius. |
| Capability Model | The authority axis's contract: safe by default, powerful by consent, evidence-anchored, revocable. |
| Observability | Verification on the authority axis: one shared trace — complete, scoped/minimal, tamper-resistant. |
| Documentation as Artifact | Contract for each increment is defined before its code; the whole contract emerges across increments. Outdated docs are bugs. |
| Reference Study | Extract patterns from others. Understand why, not just what. |
| Version Control as KB | History is the project's memory. Commits tell the story. |
| Continuous Feedback | The loop between change and knowledge should be as short as possible. |
| No Hidden Side Effects | The trace's completeness guarantee — the authority-axis mirror of "no silent success." |
| Contract-Driven Evolution | New capability/permission needs new contract item and new verification/audit; "contract wins" is a rebuttable default. |

---

## Applicability

This philosophy is domain-agnostic. The specific artifacts change:

| Domain | Contract | Verification | Safety Model | Audit |
|--------|----------|-------------|--------------|-------|
| Software | GDD / spec | Unit + integration + E2E | Capability flags + sandbox | Operation log |
| Writing | Style guide + outline | Read-back + peer review | Scope control (what to edit) | Revision history |
| Web service | API contract + SLOs | Contract tests + load tests | Auth + rate limiting | Request logs |
| Game | GDD with state rules | Playtest + automated checks | Save states + rollback | Session replay |
| Hardware | Functional spec + test plan | Bench tests + environmental tests | Safety interlocks | Test logs |
| Service design | Architecture decision records | Chaos engineering + drills | Blast radius control | Incident traces |

The four columns are the two axes. **Contract + Verification** is the correctness loop; **Safety Model + Audit** is the authority loop; the records they produce are the one shared trace. The principles are the same on both axes. The implementation adapts.