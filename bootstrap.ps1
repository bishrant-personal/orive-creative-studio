# Orive Creative Studio one-line bootstrap for Windows.
# This gets Orive Creative Studio onto your machine and starts it, in one step.
#
# Run this in PowerShell:
#   irm https://raw.githubusercontent.com/bishrant-personal/orive-creative-studio/main/bootstrap.ps1 | iex

$ErrorActionPreference = "Stop"

function Say($m) { Write-Host "`n$m" }

$target = Join-Path $HOME "orive-creative-studio"

# Make sure git is here, since we need it to fetch Orive Creative Studio.
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Say "Installing git so I can fetch Orive Creative Studio."
    winget install --exact --id Git.Git --silent --accept-source-agreements --accept-package-agreements | Out-Null
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  } else {
    Say "Please install git from git-scm.com, then run me again."
    return
  }
}

if (Test-Path (Join-Path $target ".git")) {
  Say "Updating Orive Creative Studio in $target"
  git -C $target pull --ff-only
} else {
  Say "Getting Orive Creative Studio into $target"
  git clone https://github.com/bishrant-personal/orive-creative-studio.git $target
}

Set-Location -LiteralPath $target
Say "Starting setup."
powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $target "setup.ps1")
