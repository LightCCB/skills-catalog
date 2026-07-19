#!/usr/bin/env bash
# PreToolUse gate. Blocks:
#  - Edit/Write until stages 1-4 marked (brain, caveman, md, fable-method)
#  - git push until stage 13 (autoreview) marked
# Inactive unless a pipeline was started for this session (state file exists).
IN=$(cat)
SID=$(printf '%s' "$IN" | sed -n 's/.*"session_id"[: ]*"\([^"]*\)".*/\1/p')
TOOL=$(printf '%s' "$IN" | sed -n 's/.*"tool_name"[: ]*"\([^"]*\)".*/\1/p')
S="$HOME/.claude/loadout-state/${SID:-default}.state"
[ -f "$S" ] || exit 0   # no pipeline started -> no enforcement
deny(){ printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"loadout-gate: %s. Run stages in order; mark with: bash ~/.claude/hooks/loadout-gate.sh mark %s <N>"}}' "$1" "$SID"; exit 0; }
has(){ grep -qx "$1" "$S" 2>/dev/null; }
case "$TOOL" in
  Edit|Write|MultiEdit|NotebookEdit)
    for n in 1 2 3 4; do has $n || deny "stage $n not marked — edits blocked until stages 1-4 (brain, caveman, md-files, fable-method) are done"; done;;
  Bash)
    CMD=$(printf '%s' "$IN" | sed -n 's/.*"command"[: ]*"\(.*\)".*/\1/p')
    case "$CMD" in *git\ push*|*gh\ pr\ merge*)
      has 10 || deny "stage 10 (adversary gate) not CONVINCED — push/merge blocked"
      has 14 || deny "stage 14 (autoreview) not marked — push/merge blocked";; esac;;
esac
exit 0
