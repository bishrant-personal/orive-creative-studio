# Orive Creative Studio bootstrap for Windows.
# Installs what Claude Code needs using winget, and skips anything you already have.
# It talks like a person, not a terminal. No em dashes anywhere, ever.
#
# Run it:   powershell -ExecutionPolicy Bypass -File .\setup.ps1
# Check only (changes nothing):   powershell -ExecutionPolicy Bypass -File .\setup.ps1 -CheckOnly

param(
  [switch]$CheckOnly,
  [switch]$WithDocker,
  [switch]$WithPython,
  [switch]$WithBun
)

$ErrorActionPreference = "Stop"

# Always work from the folder this script lives in, no matter where it is run from.
# This is what fixes the "it cannot find the folder" problem.
if ($PSScriptRoot) { Set-Location -LiteralPath $PSScriptRoot }

# A friendly nudge if this is a very old Windows PowerShell.
if ($PSVersionTable.PSVersion.Major -lt 5) {
  Write-Host "`nYour PowerShell is quite old. If anything fails, install a newer one from aka.ms/powershell, then run me again."
}

function Say($msg) { Write-Host "`n$msg" }
function Have($name) { return [bool](Get-Command $name -ErrorAction SilentlyContinue) }

function Refresh-Path {
  $machine = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
  $user    = [System.Environment]::GetEnvironmentVariable("Path", "User")
  $local   = Join-Path $env:USERPROFILE ".local\bin"
  $env:Path = "$machine;$user;$local"
}

function Winget-Install($id, $label) {
  Say "Installing $label."
  winget install --exact --id $id --silent --accept-source-agreements --accept-package-agreements | Out-Null
  Refresh-Path
}

# --- preflight: report what is here ---
function Preflight {
  Say "Checking what you already have."
  $rows = @()
  $checks = @(
    @{n="Node.js";    c="node"},
    @{n="npm";        c="npm"},
    @{n="git";        c="git"},
    @{n="GitHub CLI"; c="gh"},
    @{n="Claude Code";c="claude"},
    @{n="winget";     c="winget"},
    @{n="ffmpeg";     c="ffmpeg"},
    @{n="ImageMagick";c="magick"},
    @{n="pandoc";     c="pandoc"},
    @{n="yt-dlp";     c="yt-dlp"},
    @{n="PDF maker";  c="wkhtmltopdf"},
    @{n="uv (MCP)";   c="uv"}
  )
  foreach ($k in $checks) {
    if (Have $k.c) { $rows += "  {0,-12} ready" -f $k.n }
    else           { $rows += "  {0,-12} missing" -f $k.n }
  }
  # Chromium cache
  $pw = Join-Path $env:USERPROFILE "AppData\Local\ms-playwright"
  $chromium = (Test-Path $pw) -and ((Get-ChildItem $pw -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'chromium*' }).Count -gt 0)
  if ($chromium) { $rows += "  {0,-12} ready" -f "Chromium" } else { $rows += "  {0,-12} missing" -f "Chromium" }
  $rows | ForEach-Object { Write-Host $_ }
}

Say "Welcome to Orive Creative Studio. Let me get a few things ready for you."

Refresh-Path
Preflight

if ($CheckOnly) {
  Say "Check only, nothing was changed."
  return
}

# winget is the engine on Windows. It ships with Windows 11.
if (-not (Have "winget")) {
  Say "I could not find winget. It comes with Windows 11. Please update App Installer from the Microsoft Store, then run me again."
  return
}

# --- git ---
if (Have "git") { Say "git is already here." } else { Winget-Install "Git.Git" "git" }

# --- Node.js (brings npm and npx) ---
if (Have "node") { Say "Node.js is already here." } else { Winget-Install "OpenJS.NodeJS.LTS" "Node.js" }

# --- GitHub CLI ---
if (Have "gh") { Say "The GitHub tool is already here." } else { Winget-Install "GitHub.cli" "the GitHub tool" }

# --- Claude Code ---
# Native installer is the current recommended path on Windows. npm is the fallback.
# Confirm the current step against the Claude Code docs if this ever changes.
if (Have "claude") {
  Say "Claude Code is already here."
} else {
  Say "Installing Claude Code."
  try {
    Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression
    Refresh-Path
  } catch {
    Say "Trying the npm route for Claude Code."
    npm install -g @anthropic-ai/claude-code | Out-Null
    Refresh-Path
  }
}

# --- Chromium for browsing and screenshots ---
$pw = Join-Path $env:USERPROFILE "AppData\Local\ms-playwright"
$chromium = (Test-Path $pw) -and ((Get-ChildItem $pw -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'chromium*' }).Count -gt 0)
if ($chromium) {
  Say "The browser tool is already here."
} else {
  Say "Installing the browser tool, this takes a minute."
  npx --yes playwright install chromium | Out-Null
}

# --- creative and document tools the specialists use ---
# ffmpeg for video and audio, ImageMagick for images and moodboards,
# pandoc plus a PDF maker for proposals and decks, yt-dlp for reference clips.
if (Have "ffmpeg")      { Say "The video tool is already here." }    else { Winget-Install "Gyan.FFmpeg" "the video tool" }
if (Have "magick")      { Say "The image tool is already here." }    else { Winget-Install "ImageMagick.ImageMagick" "the image tool" }
if (Have "pandoc")      { Say "The document maker is already here." } else { Winget-Install "JohnMacFarlane.Pandoc" "the document maker" }
if (Have "yt-dlp")      { Say "The clip downloader is already here." } else { Winget-Install "yt-dlp.yt-dlp" "the clip downloader" }
if (Have "wkhtmltopdf") { Say "The PDF maker is already here." }      else { Winget-Install "wkhtmltopdf.wkhtmltox" "the PDF maker" }

# The wkhtmltopdf installer does not add itself to PATH, so do it for them.
$wkBin = "C:\Program Files\wkhtmltopdf\bin"
if ((Test-Path $wkBin) -and -not (Have "wkhtmltopdf")) {
  $up = [System.Environment]::GetEnvironmentVariable("Path","User")
  if ($up -notlike "*$wkBin*") {
    $up = if ([string]::IsNullOrEmpty($up)) { $wkBin } else { $up.TrimEnd(';') + ";" + $wkBin }
    [System.Environment]::SetEnvironmentVariable("Path", $up, "User")
  }
  Refresh-Path
}

# --- the MCP runner (uv) ---
# uvx runs most local MCP servers, like the Blender connector. It is small and
# the studio installs it so those tools work the moment you connect them.
if (Have "uv") { Say "The MCP runner (uv) is already here." } else { Winget-Install "astral-sh.uv" "the MCP runner (uv)" }

# --- the studio fonts ---
Say "Setting up the studio fonts."
try { & (Join-Path $PSScriptRoot "scripts\install-fonts.ps1") } catch { Say "Fonts will finish later. You can run scripts\install-fonts.ps1 anytime." }

# --- optional extras, only when asked ---
if ($WithDocker) {
  if (Have "docker") { Say "Docker is already here." } else { Winget-Install "Docker.DockerDesktop" "Docker Desktop" }
}
if ($WithPython) {
  if (Have "python") { Say "Python is already here." } else { Winget-Install "Python.Python.3.12" "Python" }
}
if ($WithBun) {
  # Bun is needed only by the Affinity MCP connector.
  if (Have "bun") { Say "Bun is already here." } else { Winget-Install "Oven-sh.Bun" "Bun" }
}

Refresh-Path
Say "All set."
Preflight

# Hand off to Orive Creative Studio for the first-run greeting and the connection wizard.
if (Have "claude") {
  Say "Starting Orive Creative Studio now. If it does not open on its own, run: claude"
  claude "Start Orive Creative Studio first run. Greet me and set up safe storage first."
} else {
  Say "Almost there. Please close this window, open a new terminal so the new tools load, then run: claude"
}
