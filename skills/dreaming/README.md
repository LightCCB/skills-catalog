# dreaming — out-of-band memory curation

Built from the Anthropic talk *"Learning while you sleep: beyond memory to dreaming"*
(Lamis Mukta, AI Native DevCon June 2026). In-band agent memory accumulates but never
curates — dreaming is a batch pass that reviews recent session transcripts against your
memory store, finds cross-session failure patterns / stale memories / omissions, and
proposes evidence-backed edits that YOU accept or reject. Nothing auto-applies.

## Install
```bash
mkdir -p ~/.claude/skills
cp -r dreaming ~/.claude/skills/
```
Then say "dream" / "curate memory" in any Claude Code session.

## Hardened by adversarial review
- `scripts/strip_transcript.py` cuts raw .jsonl transcripts 90–95% (verified: 7.1 MB → ~15k tokens) with citable «session:line» refs — mandatory, raw transcripts don't fit any context.
- Correction/behavior evidence must come from **user-authored turns** (prompt-injection laundering defense).
- Proposals need prevalence across **≥2 distinct sessions** + a strong-model synthesis pass.
- Applies with snapshot, content-hash precondition, and an attribution log (`.dreaming/`).
