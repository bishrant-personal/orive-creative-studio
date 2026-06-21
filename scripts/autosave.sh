#!/usr/bin/env bash
# Stop hook safety net: quietly save the user's work to their GitHub repo at
# the end of a session, so nothing is ever lost. The host already saves after
# each finished task. This is the backstop for anything still uncommitted.
# Guarded and quiet. It never touches secrets, since the env file is gitignored.
# No em dashes, ever.

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0

# Only act inside a git repo.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# Nothing to save? Leave quietly.
if [ -z "$(git status --porcelain 2>/dev/null)" ]; then
  exit 0
fi

git add -A
git commit -q -m "Auto-save: end of studio session" >/dev/null 2>&1 || exit 0
git push -q >/dev/null 2>&1 || true
exit 0
