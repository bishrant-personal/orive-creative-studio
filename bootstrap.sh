#!/usr/bin/env bash
# Orive Creative Studio one-line bootstrap for macOS and Linux.
# This gets Orive Creative Studio onto your machine and starts it, in one step.
#
# Run this in a terminal:
#   curl -fsSL https://raw.githubusercontent.com/bishrant-personal/orive-creative-studio/main/bootstrap.sh | bash

set -e

say() { printf "\n%s\n" "$1"; }

TARGET="$HOME/orive-creative-studio"

# Make sure git is here, since we need it to fetch Orive Creative Studio.
if ! command -v git >/dev/null 2>&1; then
  say "Please install git first, then run me again. On mac it comes with the Xcode command line tools, on Linux use your package manager."
  exit 1
fi

if [ -d "$TARGET/.git" ]; then
  say "Updating Orive Creative Studio in $TARGET"
  git -C "$TARGET" pull --ff-only || true
else
  say "Getting Orive Creative Studio into $TARGET"
  git clone https://github.com/bishrant-personal/orive-creative-studio.git "$TARGET"
fi

cd "$TARGET"
chmod +x setup.sh 2>/dev/null || true
say "Starting setup."
./setup.sh
