#!/usr/bin/env bash
# Home Studio bootstrap for macOS and Linux.
# Installs what Claude Code needs, and skips anything you already have.
# It talks like a person, not a terminal. Plain progress lines, no raw logs.
# No em dashes anywhere, ever.
#
# Run it:        ./setup.sh
# Check only:    ./setup.sh --check   (changes nothing, just reports)

set -e

# Always work from the folder this script lives in, no matter where it is run from.
cd "$(cd "$(dirname "$0")" 2>/dev/null && pwd)" 2>/dev/null || true

CHECK_ONLY="no"
WITH_DOCKER="no"
WITH_PYTHON="no"
for arg in "$@"; do
  case "$arg" in
    --check)        CHECK_ONLY="yes" ;;
    --with-docker)  WITH_DOCKER="yes" ;;
    --with-python)  WITH_PYTHON="yes" ;;
  esac
done

say()  { printf "\n%s\n" "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }

OS="unknown"
case "$(uname -s 2>/dev/null)" in
  Linux*)   OS="linux" ;;
  Darwin*)  OS="mac" ;;
  MINGW*|MSYS*|CYGWIN*) OS="windows" ;;
esac

# On Windows, the automated path is the PowerShell script.
if [ "$OS" = "windows" ]; then
  say "It looks like you are on Windows."
  say "For the automated setup, run this in PowerShell instead:"
  say "  powershell -ExecutionPolicy Bypass -File .\\setup.ps1"
  exit 0
fi

# Pick the package manager for this machine.
PM=""
if   [ "$OS" = "mac" ]; then PM="brew"
elif have apt-get;     then PM="apt"
elif have dnf;         then PM="dnf"
elif have pacman;      then PM="pacman"
fi

pm_install() {
  # pm_install <package>
  case "$PM" in
    brew)   brew install "$1" ;;
    apt)    sudo apt-get update -y >/dev/null 2>&1; sudo apt-get install -y "$1" ;;
    dnf)    sudo dnf install -y "$1" ;;
    pacman) sudo pacman -S --noconfirm "$1" ;;
    *)      return 1 ;;
  esac
}

preflight() {
  say "Checking what you already have."
  for pair in "Node.js:node" "npm:npm" "git:git" "GitHub CLI:gh" "Claude Code:claude" "ffmpeg:ffmpeg" "ImageMagick:magick" "pandoc:pandoc" "yt-dlp:yt-dlp" "PDF maker:wkhtmltopdf"; do
    label="${pair%%:*}"; cmd="${pair##*:}"
    if have "$cmd"; then printf "  %-12s ready\n" "$label"; else printf "  %-12s missing\n" "$label"; fi
  done
  if [ -d "$HOME/.cache/ms-playwright" ] && ls "$HOME/.cache/ms-playwright" 2>/dev/null | grep -q chromium; then
    printf "  %-12s ready\n" "Chromium"
  else
    printf "  %-12s missing\n" "Chromium"
  fi
}

say "Welcome to Home Studio. Let me get a few things ready for you."
preflight

if [ "$CHECK_ONLY" = "yes" ]; then
  say "Check only, nothing was changed."
  exit 0
fi

# On mac, make sure Homebrew exists, it is the engine there.
if [ "$OS" = "mac" ] && ! have brew; then
  say "Installing Homebrew, the mac package manager."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || true)"
fi

# --- git ---
if have git; then say "git is already here."; else say "Installing git."; pm_install git || say "Please install git, then run me again."; fi

# --- Node.js (brings npm and npx) ---
if have node; then
  say "Node.js is already here."
else
  say "Installing Node.js, Claude Code needs it."
  if [ "$PM" = "apt" ]; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - >/dev/null 2>&1 && sudo apt-get install -y nodejs || say "Please install Node.js from nodejs.org, then run me again."
  else
    pm_install node || say "Please install Node.js from nodejs.org, then run me again."
  fi
fi

# --- GitHub CLI ---
if have gh; then say "The GitHub tool is already here."; else say "Installing the GitHub tool."; pm_install gh || say "Please install the GitHub CLI from cli.github.com, then run me again."; fi

# --- Claude Code ---
# Native installer is the current recommended path. npm is the fallback.
# Confirm the current step against the Claude Code docs if this ever changes.
if have claude; then
  say "Claude Code is already here."
else
  say "Installing Claude Code."
  curl -fsSL https://claude.ai/install.sh | bash || npm install -g @anthropic-ai/claude-code >/dev/null 2>&1 || say "See the Claude Code docs for the current install step."
  export PATH="$HOME/.local/bin:$PATH"
fi

# --- Chromium for browsing and screenshots ---
if [ -d "$HOME/.cache/ms-playwright" ] && ls "$HOME/.cache/ms-playwright" 2>/dev/null | grep -q chromium; then
  say "The browser tool is already here."
else
  say "Installing the browser tool, this takes a minute."
  npx --yes playwright install chromium >/dev/null 2>&1 || say "The browser tool will finish setting up the first time a specialist needs it."
  [ "$OS" = "linux" ] && (npx --yes playwright install-deps chromium >/dev/null 2>&1 || true)
fi

# --- creative and document tools the specialists use ---
# ffmpeg for video and audio, ImageMagick for images and moodboards,
# pandoc plus a PDF maker for proposals and decks, yt-dlp for reference clips.
have ffmpeg                  || { say "Installing the video tool."; pm_install ffmpeg || say "Please install ffmpeg, then run me again."; }
{ have magick || have convert; } || { say "Installing the image tool."; pm_install imagemagick || say "Please install ImageMagick."; }
have pandoc                  || { say "Installing the document maker."; pm_install pandoc || say "Please install pandoc."; }
have yt-dlp                  || { say "Installing the clip downloader."; pm_install yt-dlp || say "yt-dlp is optional, you can add it later."; }
have wkhtmltopdf             || { say "Installing the PDF maker."; { [ "$OS" = "mac" ] && brew install --cask wkhtmltopdf; } || pm_install wkhtmltopdf || say "The PDF maker is optional, you can add it later."; }

# --- optional extras, only when asked ---
if [ "$WITH_DOCKER" = "yes" ]; then
  if have docker; then say "Docker is already here."; else say "Installing Docker."; { [ "$OS" = "mac" ] && brew install --cask docker; } || pm_install docker.io || say "Please install Docker Desktop from docker.com."; fi
fi
if [ "$WITH_PYTHON" = "yes" ]; then
  if have python3; then say "Python is already here."; else say "Installing Python."; pm_install python3 || say "Please install Python 3 from python.org."; fi
fi

say "All set."
preflight

# Hand off to Home Studio for the first-run greeting and the connection wizard.
if have claude; then
  say "Starting Home Studio now. If it does not open on its own, run: claude"
  claude "Start Home Studio first run. Greet me and set up safe storage first."
else
  say "Almost there. Please open a new terminal so the new tools load, then run: claude"
fi
