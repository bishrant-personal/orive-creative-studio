#!/usr/bin/env bash
# Home Studio bootstrap.
# Auto-installs what Claude Code needs, then hands off to the studio.
# It talks like a person, not a terminal. Plain progress lines, no raw logs.
# No em dashes anywhere, ever.

set -e

say() { printf "\n%s\n" "$1"; }

OS="unknown"
case "$(uname -s 2>/dev/null)" in
  Linux*)   OS="linux" ;;
  Darwin*)  OS="mac" ;;
  MINGW*|MSYS*|CYGWIN*) OS="windows" ;;
esac

say "Welcome to Home Studio. Let me get a few things ready for you."
say "This runs once and takes a couple of minutes."

# --- git ---
if command -v git >/dev/null 2>&1; then
  say "git is already here."
else
  say "Installing git, one moment."
  case "$OS" in
    mac)     command -v brew >/dev/null 2>&1 && brew install git || say "Please install git from git-scm.com, then run me again." ;;
    linux)   sudo apt-get update -y >/dev/null 2>&1 && sudo apt-get install -y git || say "Please install git with your package manager, then run me again." ;;
    windows) say "On Windows, please install Git for Windows from git-scm.com, then run me again from Git Bash." ; exit 1 ;;
    *)       say "Please install git, then run me again." ; exit 1 ;;
  esac
fi

# --- Node.js (Claude Code needs it) ---
if command -v node >/dev/null 2>&1; then
  say "Node.js is already here."
else
  say "Installing Node.js, Claude Code needs it."
  case "$OS" in
    mac)     command -v brew >/dev/null 2>&1 && brew install node || say "Please install Node.js from nodejs.org, then run me again." ;;
    linux)   curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - >/dev/null 2>&1 && sudo apt-get install -y nodejs || say "Please install Node.js from nodejs.org, then run me again." ;;
    windows) say "On Windows, please install Node.js LTS from nodejs.org, then run me again from Git Bash." ; exit 1 ;;
    *)       say "Please install Node.js, then run me again." ; exit 1 ;;
  esac
fi

# --- GitHub CLI ---
if command -v gh >/dev/null 2>&1; then
  say "The GitHub tool is already here."
else
  say "Installing the GitHub tool."
  case "$OS" in
    mac)     command -v brew >/dev/null 2>&1 && brew install gh || say "Please install the GitHub CLI from cli.github.com, then run me again." ;;
    linux)   (type -p curl >/dev/null && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null 2>&1) ; sudo apt-get update -y >/dev/null 2>&1 && sudo apt-get install -y gh || say "Please install the GitHub CLI from cli.github.com, then run me again." ;;
    windows) say "On Windows, please install the GitHub CLI from cli.github.com, then run me again from Git Bash." ; exit 1 ;;
    *)       say "Please install the GitHub CLI, then run me again." ; exit 1 ;;
  esac
fi

# --- Claude Code ---
# Confirm the current install command against the Claude Code docs at build time, it can change.
if command -v claude >/dev/null 2>&1; then
  say "Claude Code is already here."
else
  say "Installing Claude Code."
  npm install -g @anthropic-ai/claude-code >/dev/null 2>&1 || say "If that did not work, see the Claude Code docs for the current install step."
fi

# --- Chromium for browsing and screenshots ---
say "Installing the browser tool, this takes a minute."
npx --yes playwright install chromium >/dev/null 2>&1 || say "The browser tool will finish setting up the first time a specialist needs it."

say "All set. Starting Home Studio now."
say "If it does not open on its own, run: claude"

# Hand off to Home Studio so it can run the first-run greeting and the connection wizard.
if command -v claude >/dev/null 2>&1; then
  claude "Start Home Studio first run. Greet me and set up safe storage first."
fi
