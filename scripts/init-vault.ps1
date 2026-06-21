# Create the studio's local memory vault if it does not exist.
# Safe to run repeatedly. It never overwrites existing files.
# No em dashes, ever.

$vault = if ($env:ORIVE_VAULT) { $env:ORIVE_VAULT } else { Join-Path $HOME "orive-vault" }

if (Test-Path (Join-Path $vault ".git")) {
  Write-Host "Vault already exists at $vault"
  return
}

Write-Host "Creating your studio memory at $vault"
$dirs = @(
  "sessions\mcp-log", "sessions\recipes", "patterns\client-briefs",
  "prompts\saved", "prompts\templates", "connections"
)
foreach ($d in $dirs) { New-Item -ItemType Directory -Force -Path (Join-Path $vault $d) | Out-Null }

foreach ($f in @("tool-usage","content-patterns","feedback-log","mcp-chains")) {
  $p = Join-Path $vault "patterns\$f.json"
  if (-not (Test-Path $p)) { Set-Content -Path $p -Value "{}" -Encoding utf8 }
}
$il = Join-Path $vault "connections\install-log.json"
if (-not (Test-Path $il)) { Set-Content -Path $il -Value "[]" -Encoding utf8 }

foreach ($d in @("sessions\mcp-log","sessions\recipes","patterns\client-briefs","prompts\saved","prompts\templates")) {
  $k = Join-Path $vault "$d\.gitkeep"
  if (-not (Test-Path $k)) { Set-Content -Path $k -Value "" -Encoding utf8 }
}

$readme = @"
# Orive Creative Studio vault

This is the studio's local memory. It holds session summaries, an MCP tool-call
log, learned patterns, replayable recipes, and saved prompts. It is local only
and is never pushed to a remote unless you ask. It holds summaries, never full
payloads or credentials.
"@
Set-Content -Path (Join-Path $vault "README.md") -Value $readme -Encoding utf8

Push-Location $vault
git init -q; git add -A; git commit -q -m "Create the studio vault"
Pop-Location
Write-Host "Done. Your studio memory is ready at $vault"
