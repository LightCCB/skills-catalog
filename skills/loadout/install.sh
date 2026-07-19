#!/usr/bin/env bash
# loadout installer — copies the skill, command, hooks, and bundled deps into
# ~/.claude, then installs plugin dependencies via the Claude Code CLI.
# Safe to re-run. Never edits settings.json (prints the snippet instead).
set -euo pipefail
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"   # .../skills/loadout
REPO="$(cd "$SRC/../.." && pwd)"
CLA="$HOME/.claude"
mkdir -p "$CLA/skills" "$CLA/commands" "$CLA/hooks" "$CLA/loadout-state"

echo "== core skill =="
rm -rf "$CLA/skills/skill-router"; cp -R "$SRC" "$CLA/skills/skill-router"
rm -rf "$CLA/skills/skill-router/install.sh" "$CLA/skills/skill-router/commands" "$CLA/skills/skill-router/hooks" 2>/dev/null || true
cp "$SRC/commands/loadout.md" "$CLA/commands/loadout.md"
cp "$SRC/hooks/loadout-gate.sh" "$SRC/hooks/loadout-enforce.sh" "$CLA/hooks/"
chmod +x "$CLA/hooks/loadout-gate.sh" "$CLA/hooks/loadout-enforce.sh"

echo "== bundled skills (this repo) =="
for s in working-philosophy research-methodology; do
  [ -d "$REPO/skills/$s" ] && { rm -rf "$CLA/skills/$s"; cp -R "$REPO/skills/$s" "$CLA/skills/$s"; echo "  $s"; }
done

echo "== plugin dependencies (claude CLI) =="
if command -v claude >/dev/null 2>&1; then
  add(){ claude plugin marketplace add "$1" >/dev/null 2>&1 || true; claude plugin install "$2" >/dev/null 2>&1 && echo "  $2" || echo "  $2 (skipped/already)"; }
  add Sahir619/fable-method fable@fable-method
  add seldonframe/reflect reflect@reflect
  add JuliusBrussee/caveman caveman@caveman
  add mattpocock/skills mattpocock-skills@mattpocock
  add jame581/skillsmith logseq-brain@skillsmith
else
  echo "  claude CLI not found — install plugins manually (see README)"
fi

echo "== folder-skill dependencies (npx skills) =="
if command -v npx >/dev/null 2>&1; then
  npx -y skills add https://github.com/affaan-m/ECC --skill product-capability >/dev/null 2>&1 && echo "  product-capability" || echo "  product-capability (manual: see README)"
  npx -y skills add https://github.com/openclaw/openclaw --skill autoreview >/dev/null 2>&1 && echo "  autoreview" || echo "  autoreview (manual: see README)"
else
  echo "  npx not found — install product-capability + autoreview manually"
fi
echo "  graphify + GSD: install manually (see README dependency links)"

cat <<'SNIP'

== FINAL MANUAL STEP — enforcement hook ==
Add this entry to the "PreToolUse" array in ~/.claude/settings.json, then
restart Claude Code:

  {
    "matcher": "Edit|Write|MultiEdit|NotebookEdit|Bash",
    "hooks": [
      { "type": "command",
        "command": "bash \"$HOME/.claude/hooks/loadout-enforce.sh\"",
        "timeout": 5 }
    ]
  }

Done. New sessions get /loadout; enforcement activates after the hook+restart.
SNIP
