# What Home Studio needs to run

This is the full list of software Home Studio depends on, and what installs it. You do not have to read this. The setup scripts install everything for you and skip anything you already have. This file is here so the list is honest and visible. No em dashes, ever.

## Required

These must be present for the studio to work. The setup scripts install any that are missing.

| Software | Why it is needed | Installed by |
|---|---|---|
| Node.js (LTS) and npm | Claude Code runs on it, and npx fetches the browser tool | winget on Windows, Homebrew on mac, apt on Linux |
| git | Version control and the auto-save that backs up your work | same |
| GitHub CLI (gh) | One-click sign-in, private repo creation, and push access | same |
| Claude Code | The agent runtime the whole studio lives in | official installer, with npm as a fallback |
| Chromium (via Playwright) | Lets the Research and Content specialists open a live page and capture a screenshot | npx playwright install chromium |

## Creative and document tools

The creative specialists need a few real tools to make actual files, not just text. The setup scripts install these too, and skip any you already have.

| Software | Why it is needed | Used by |
|---|---|---|
| ffmpeg | Video and audio work: frame grabs, transcode, thumbnails, and reading clip details | Videographer, Cinematographer, Content |
| ImageMagick | Image work: resize, convert, and build moodboard contact sheets | Brand, Content, Concept artist |
| pandoc | Turn a brief into a polished document: proposals, quotes, brochures, and decks | Pricing, Hospitality, Brand, Research |
| wkhtmltopdf | The PDF engine pandoc uses to render proposals and print collateral | Pricing, Hospitality |
| yt-dlp | Pull a reference clip to study its pacing or look | Videographer, Cinematographer |

## Manual prerequisite for desktop control

Layer 2 of desktop control, where the studio takes direct control of the screen for an app with no connector or API, runs through the Claude desktop app on a Pro or Max plan, on macOS or Windows. That is a sign-in and a plan, not a package, so the setup scripts cannot install it. The studio prefers connectors and the browser first and only reaches for screen control when nothing else fits. See the `desktop-control` skill.

## Installer mechanism, one per operating system

The setup scripts use the right one for your machine automatically.

| Operating system | Package manager | Notes |
|---|---|---|
| Windows 11 | winget | Built into Windows, nothing to install first |
| macOS | Homebrew | Installed automatically if missing |
| Linux | apt, dnf, or pacman | Uses whatever your distro provides |

## Optional, only if a task needs it

These are not installed by default. The studio runs fine without them. Install them only if you reach a task that asks for them.

| Software | When you would want it |
|---|---|
| Docker Desktop | Only if you choose to run a containerized MCP server locally. The default setup uses hosted and remote MCP servers, so this is not required |
| Python 3 | Only if you connect an MCP server that is built in Python. The default connections do not need it |
| curl and jq | Convenience for raw API calls in the shell. Node already covers this, so they are optional |

## No install needed, these connect with a sign-in or a key

These are hosted or remote, so there is nothing to install. The /connect wizard sets them up with a sign-in or an API key when a task needs them.

- Figma, Slack, Outline, Google: sign-in through the connection wizard
- GitHub MCP (official): remote, used for reading repos and issues
- Meta Ads MCP (official): sign-in, read-and-stage only
- Pexels, Unsplash, Pixabay: a free API key kept in the local env file

## How to run it

Windows:

```
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

macOS or Linux:

```
./setup.sh
```

To only check what is installed without changing anything:

```
powershell -ExecutionPolicy Bypass -File .\setup.ps1 -CheckOnly
./setup.sh --check
```
