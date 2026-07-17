#!/usr/bin/env bash
# Installs the master workflow skills + the SessionStart routing hook for the current user.
# Run from the repo root:  ./install.sh
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# 1. Skills
mkdir -p "$CLAUDE_DIR/skills"
cp -r "$REPO/skills/"* "$CLAUDE_DIR/skills/"
echo "Skills copied to $CLAUDE_DIR/skills"

# 2. Hook payload
mkdir -p "$CLAUDE_DIR/hooks"
cp "$REPO/hooks/master-workflow-reminder.json" "$CLAUDE_DIR/hooks/"
echo "Hook payload copied to $CLAUDE_DIR/hooks"

# 3. Merge the SessionStart hook into ~/.claude/settings.json (idempotent)
python3 - "$CLAUDE_DIR/settings.json" <<'PYEOF'
import json, os, sys
path = sys.argv[1]
settings = {}
if os.path.exists(path):
    with open(path) as f:
        settings = json.load(f)
entries = settings.setdefault("hooks", {}).setdefault("SessionStart", [])
if any("master-workflow-reminder.json" in h.get("command", "")
       for e in entries for h in e.get("hooks", [])):
    print("SessionStart hook already configured - skipped.")
else:
    entries.append({"hooks": [{
        "type": "command",
        "command": 'cat "$HOME/.claude/hooks/master-workflow-reminder.json"',
        "timeout": 10,
        "statusMessage": "Loading master-workflow routing rules",
    }]})
    with open(path, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
    print(f"SessionStart hook added to {path}")
PYEOF

echo ""
echo "Done. Restart Claude Code (or start a new session) to activate the skills and the routing hook."
