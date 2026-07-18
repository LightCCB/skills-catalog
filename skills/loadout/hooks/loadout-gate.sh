#!/usr/bin/env bash
# loadout-gate — manual CLI for the pipeline state.
#   loadout-gate start <session_id>     begin enforced pipeline
#   loadout-gate mark <session_id> <N>  mark stage N done (1-13)
#   loadout-gate status <session_id>
#   loadout-gate off <session_id>       disable enforcement (trivial task)
S="$HOME/.claude/loadout-state/${2:-default}.state"
case "$1" in
  start)  touch "$S"; echo "pipeline started: $S";;
  mark)   grep -qx "$3" "$S" 2>/dev/null || echo "$3" >> "$S"; echo "marked $3";;
  status) [ -f "$S" ] && sort -n "$S" | tr '\n' ' ' || echo "no pipeline";;
  off)    rm -f "$S"; echo "enforcement off";;
esac
