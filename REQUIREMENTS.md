# What Orive Creative Studio needs to run

This is the full list of software Orive Creative Studio depends on, and what installs it. You do not have to read this. The setup scripts install everything for you and skip anything you already have. This file is here so the list is honest and visible. No em dashes, ever.

## Before you install (two free apps, by hand)

Only two things are set up by hand first. Everything below them is automatic.

| App | Why | Link |
|---|---|---|
| Claude desktop app | where the studio lives and talks to you | https://claude.ai/download |
| A terminal | the window where you paste the one-line setup. Warp, Ghostty, or VS Code, pick one | https://www.warp.dev/ , https://ghostty.org/ , https://code.visualstudio.com/ |

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
| uv | Runs most local MCP servers through uvx, like the Blender connector | the MCP-based tools in creative-toolbox and fashion-knowledge |
| Studio fonts | The curated type set installed per user, used for all design and document work | Brand, Content, Fashion, Hospitality, document-design |

The studio fonts are Inter, IBM Plex Sans, IBM Plex Mono, Montserrat, Lato, Nunito, Playfair Display, Archivo Black, Manrope, Bitcount Prop Single, Chelsea Market, Libre Baskerville, Changa One, EB Garamond, Urbanist, League Script, Dancing Script, and Yesteryear, fetched from the open google/fonts library by `scripts/install-fonts`. Google Sans is proprietary and not in the open library, so the studio uses Inter or Manrope in its place unless you supply the file.

## Creative tools you connect or install when you choose them

The studio recommends and connects many creative tools through the `creative-toolbox` and `fashion-knowledge` skills. Most are not auto-installed, because they are either a one-click connector or a large or paid desktop app. The setup installs only the small enablers so a tool works the moment you connect it. The heavy apps are never downloaded silently, the studio guides their install per tool, with real links, when you choose that tool.

| Tool | How you get it | Prerequisite the setup handles |
|---|---|---|
| Adobe, Figma, Canva, Higgsfield | one-click connector or hosted MCP, sign-in only | none |
| Blender (MCP) | install Blender yourself, then the studio adds the connector | uv, installed by default |
| DaVinci Resolve (MCP) | needs Resolve Studio (paid) and Python | Python, via `--with-python` or `-WithPython` |
| Affinity (MCP) | install Affinity yourself, macOS best | Bun, via `--with-bun` or `-WithBun` |
| CLO3D, Browzwear, Style3D, pattern CAD | standalone or enterprise apps, you install and license | none, the studio guides setup |

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
| Docker Desktop | Only if you choose to run a containerized MCP server locally. Add it with `--with-docker` or `-WithDocker` |
| Python 3 | Only for local MCP servers that need it, like the DaVinci Resolve connector. Add it with `--with-python` or `-WithPython` |
| Bun | Only for the Affinity MCP connector. Add it with `--with-bun` or `-WithBun` |
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
