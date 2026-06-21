# Install the studio's font set from the open google/fonts library, per user.
# Safe to run repeatedly, it skips fonts already present. No em dashes, ever.
# Google Sans is proprietary and not in the open library, so it is skipped.

param([string]$FontDir = (Join-Path $env:LOCALAPPDATA "Microsoft\Windows\Fonts"))
$ErrorActionPreference = "Continue"

$names = @(
  "Inter","IBM Plex Sans","IBM Plex Mono","Montserrat","Lato","Nunito",
  "Playfair Display","Archivo Black","Manrope","Bitcount Prop Single",
  "Chelsea Market","Libre Baskerville","Changa One","EB Garamond",
  "Urbanist","League Script","Dancing Script","Yesteryear"
)

New-Item -ItemType Directory -Force $FontDir | Out-Null
$hdr = @{ "User-Agent" = "orive-creative-studio" }
$reg = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

Write-Host "Installing the studio fonts, this is a quick download."
foreach ($n in $names) {
  $slug = ($n.ToLower() -replace '[^a-z0-9]','')
  $items = $null
  foreach ($d in @("ofl","apache","ufl")) {
    try { $items = Invoke-RestMethod "https://api.github.com/repos/google/fonts/contents/$d/$slug" -Headers $hdr -ErrorAction Stop; break } catch { $items = $null }
  }
  if (-not $items) { Write-Host "  skip $n (not in the open font library)"; continue }
  $ttfs = @($items | Where-Object { $_.name -like "*.ttf" })
  if ($ttfs.Count -eq 0) { Write-Host "  skip $n (no ttf found)"; continue }
  foreach ($t in $ttfs) {
    $dest = Join-Path $FontDir $t.name
    if (-not (Test-Path $dest)) {
      try { Invoke-WebRequest $t.download_url -OutFile $dest -UseBasicParsing -Headers $hdr -ErrorAction Stop } catch { continue }
    }
    $face = [System.IO.Path]::GetFileNameWithoutExtension($t.name)
    try { New-ItemProperty -Path $reg -Name "$face (TrueType)" -Value $dest -PropertyType String -Force | Out-Null } catch {}
  }
  Write-Host "  installed $n"
}
Write-Host "Fonts done. The studio uses these for design and document work."
