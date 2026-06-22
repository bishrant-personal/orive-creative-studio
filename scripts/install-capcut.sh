#!/usr/bin/env bash
# Installs the CapCut MCP backend for Orive Creative Studio on macOS or Linux.
# It clones the VectCutAPI engine into vendor/, builds a Python venv, and points
# the studio's .mcp.json at the POSIX venv. It talks like a person, not a
# terminal. No em dashes anywhere, ever.
#
# Run it:   bash scripts/install-capcut.sh

set -euo pipefail

say() { echo "  $1"; }
have() { command -v "$1" >/dev/null 2>&1; }

# The repo root is the parent of this scripts folder.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VENDOR_DIR="$REPO_ROOT/vendor"
APP_DIR="$VENDOR_DIR/VectCutAPI"
REPO_URL="https://github.com/sun-guannan/VectCutAPI.git"

say "Setting up CapCut for the studio."

if ! have git;    then say "I need git first. Run setup.sh, then run me again."; exit 1; fi
if ! have python3; then say "I need Python 3.10 or newer. Install it, then run me again."; exit 1; fi
if ! have ffmpeg; then say "Note: ffmpeg is missing. Run setup.sh to add it, CapCut export needs it."; fi

mkdir -p "$VENDOR_DIR"
if [ -d "$APP_DIR/.git" ]; then
  say "Updating the CapCut engine."
  git -C "$APP_DIR" pull --ff-only >/dev/null
else
  say "Downloading the CapCut engine."
  git clone --depth 1 "$REPO_URL" "$APP_DIR" >/dev/null
fi

VENV_PY="$APP_DIR/venv-capcut/bin/python"
if [ ! -x "$VENV_PY" ]; then
  say "Building the Python environment."
  python3 -m venv "$APP_DIR/venv-capcut"
fi
say "Installing the parts, this takes a minute."
"$VENV_PY" -m pip install --upgrade pip >/dev/null
"$VENV_PY" -m pip install -r "$APP_DIR/requirements.txt" >/dev/null
"$VENV_PY" -m pip install -r "$APP_DIR/requirements-mcp.txt" >/dev/null

# The committed .mcp.json points at the Windows venv (Scripts/python.exe).
# On POSIX the venv python lives at bin/python, so rewrite the two paths.
MCP_JSON="$REPO_ROOT/.mcp.json"
if [ -f "$MCP_JSON" ]; then
  say "Pointing .mcp.json at the POSIX Python."
  python3 - "$MCP_JSON" <<'PY'
import json, sys
p = sys.argv[1]
with open(p) as f:
    data = json.load(f)
cap = data.get("mcpServers", {}).get("capcut")
if cap:
    cap["command"] = "${CLAUDE_PROJECT_DIR:-.}/vendor/VectCutAPI/venv-capcut/bin/python"
    cap["args"] = ["${CLAUDE_PROJECT_DIR:-.}/vendor/VectCutAPI/mcp_server.py"]
    with open(p, "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")
PY
fi

if "$VENV_PY" -c "import mcp_server; print(mcp_server.CAPCUT_AVAILABLE)" 2>/dev/null | grep -q True; then
  say "CapCut is connected. The studio can build and edit CapCut drafts now."
else
  say "Installed. If a tool call fails the first time, try once more in a minute."
fi

say "Done. The studio talks to CapCut through the capcut server in .mcp.json."
