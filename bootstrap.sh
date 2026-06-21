#!/usr/bin/env bash
# Home Studio one-line bootstrap for macOS and Linux.
# This gets Home Studio onto your machine and starts it, in one step.
#
# Run this in a terminal:
#   curl -fsSL https://raw.githubusercontent.com/bishrant-personal/home-studio/main/bootstrap.sh | bash

set -e

say() { printf "\n%s\n" "$1"; }

TARGET="$HOME/home-studio"

# Make sure git is here, since we need it to fetch Home Studio.
if ! command -v git >/dev/null 2>&1; then
  say "Please install git first, then run me again. On mac it comes with the Xcode command line tools, on Linux use your package manager."
  exit 1
fi

if [ -d "$TARGET/.git" ]; then
  say "Updating Home Studio in $TARGET"
  git -C "$TARGET" pull --ff-only || true
else
  say "Getting Home Studio into $TARGET"
  git clone https://github.com/bishrant-personal/home-studio.git "$TARGET"
fi

cd "$TARGET"
chmod +x setup.sh 2>/dev/null || true
say "Starting setup."
./setup.sh
