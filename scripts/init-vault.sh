#!/usr/bin/env bash
# Create the studio's local memory vault if it does not exist.
# Safe to run repeatedly. It never overwrites existing files.
# No em dashes, ever.

VAULT="${ORIVE_VAULT:-$HOME/orive-vault}"

if [ -d "$VAULT/.git" ]; then
  echo "Vault already exists at $VAULT"
  exit 0
fi

echo "Creating your studio memory at $VAULT"
mkdir -p "$VAULT/sessions/mcp-log" "$VAULT/sessions/recipes" \
         "$VAULT/patterns/client-briefs" \
         "$VAULT/prompts/saved" "$VAULT/prompts/templates" \
         "$VAULT/connections"

# Seed the pattern files so they exist and parse.
for f in tool-usage content-patterns feedback-log mcp-chains; do
  [ -f "$VAULT/patterns/$f.json" ] || printf '{}\n' > "$VAULT/patterns/$f.json"
done
[ -f "$VAULT/connections/install-log.json" ] || printf '[]\n' > "$VAULT/connections/install-log.json"

# Keep empty folders in git.
for d in sessions/mcp-log sessions/recipes patterns/client-briefs prompts/saved prompts/templates; do
  [ -f "$VAULT/$d/.gitkeep" ] || printf '' > "$VAULT/$d/.gitkeep"
done

cat > "$VAULT/README.md" <<'EOF'
# Orive Creative Studio vault

This is the studio's local memory. It holds session summaries, an MCP tool-call
log, learned patterns, replayable recipes, and saved prompts. It is local only
and is never pushed to a remote unless you ask. It holds summaries, never full
payloads or credentials.
EOF

( cd "$VAULT" && git init -q && git add -A && git commit -q -m "Create the studio vault" )
echo "Done. Your studio memory is ready at $VAULT"
