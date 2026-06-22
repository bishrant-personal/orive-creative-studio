# Installs the CapCut MCP backend for Orive Creative Studio on Windows.
# It clones the VectCutAPI engine into vendor/, builds a Python venv, and
# leaves the studio ready to drive CapCut. It talks like a person, not a
# terminal. No em dashes anywhere, ever.
#
# Run it:   powershell -ExecutionPolicy Bypass -File .\scripts\install-capcut.ps1

$ErrorActionPreference = "Stop"

function Say($m) { Write-Host "  $m" }
function Have($c) { return [bool](Get-Command $c -ErrorAction SilentlyContinue) }

# The repo root is the parent of this scripts folder.
$RepoRoot = Split-Path -Parent $PSScriptRoot
$VendorDir = Join-Path $RepoRoot "vendor"
$AppDir = Join-Path $VendorDir "VectCutAPI"
$RepoUrl = "https://github.com/sun-guannan/VectCutAPI.git"

Say "Setting up CapCut for the studio."

# CapCut works by writing draft projects you open in the CapCut app, so the app must be installed.
$capcutLocal = Join-Path $env:LOCALAPPDATA "CapCut"
if (-not (Test-Path $capcutLocal)) {
  Say "Heads up: I could not find CapCut installed. Get it from capcut.com, then run me again."
}

if (-not (Have "git"))    { Say "I need git first. Run setup.ps1, then run me again."; exit 1 }
if (-not (Have "python")) { Say "I need Python 3.10 or newer. Run setup.ps1 -WithPython, then run me again."; exit 1 }
if (-not (Have "ffmpeg")) { Say "Note: ffmpeg is missing. Run setup.ps1 to add it, CapCut export needs it." }

# Clone or update the engine.
New-Item -ItemType Directory -Force -Path $VendorDir | Out-Null
if (Test-Path (Join-Path $AppDir ".git")) {
  Say "Updating the CapCut engine."
  git -C $AppDir pull --ff-only | Out-Null
} else {
  Say "Downloading the CapCut engine."
  git clone --depth 1 $RepoUrl $AppDir | Out-Null
}

# Build the Python environment.
$VenvPy = Join-Path $AppDir "venv-capcut\Scripts\python.exe"
if (-not (Test-Path $VenvPy)) {
  Say "Building the Python environment."
  python -m venv (Join-Path $AppDir "venv-capcut")
}
Say "Installing the parts, this takes a minute."
& $VenvPy -m pip install --upgrade pip | Out-Null
& $VenvPy -m pip install -r (Join-Path $AppDir "requirements.txt") | Out-Null
& $VenvPy -m pip install -r (Join-Path $AppDir "requirements-mcp.txt") | Out-Null

# Quick check that the engine loads.
Push-Location $AppDir
$check = & $VenvPy -c "import mcp_server; print(mcp_server.CAPCUT_AVAILABLE)" 2>&1
Pop-Location
if ("$check" -match "True") {
  Say "CapCut is connected. The studio can build and edit CapCut drafts now."
} else {
  Say "Installed, but the engine did not load on the first try."
  Say "On Windows, Smart App Control can block a fresh library on first run while it checks it. Try once more in a minute."
}

Say "Done. The studio talks to CapCut through the capcut server in .mcp.json."
