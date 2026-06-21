# Home Studio bootstrap for Windows.
# Installs what Claude Code needs using winget, and skips anything you already have.
# It talks like a person, not a terminal. No em dashes anywhere, ever.
#
# Run it:   powershell -ExecutionPolicy Bypass -File .\setup.ps1
# Check only (changes nothing):   powershell -ExecutionPolicy Bypass -File .\setup.ps1 -CheckOnly

param(
  [switch]$CheckOnly,
  [switch]$WithDocker,
  [switch]$WithPython
)

$ErrorActionPreference = "Stop"

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
    @{n="winget";     c="winget"}
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

Say "Welcome to Home Studio. Let me get a few things ready for you."

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

# --- optional extras, only when asked ---
if ($WithDocker) {
  if (Have "docker") { Say "Docker is already here." } else { Winget-Install "Docker.DockerDesktop" "Docker Desktop" }
}
if ($WithPython) {
  if (Have "python") { Say "Python is already here." } else { Winget-Install "Python.Python.3.12" "Python" }
}

Refresh-Path
Say "All set."
Preflight

# Hand off to Home Studio for the first-run greeting and the connection wizard.
if (Have "claude") {
  Say "Starting Home Studio now. If it does not open on its own, run: claude"
  claude "Start Home Studio first run. Greet me and set up safe storage first."
} else {
  Say "Almost there. Please close this window, open a new terminal so the new tools load, then run: claude"
}
