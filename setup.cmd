@echo off
REM Orive Creative Studio easy start for Windows.
REM Double-click this file, or run it. It launches the real setup in
REM PowerShell with the right settings, from this folder, so you never
REM have to open PowerShell or think about execution policy yourself.

cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1" %*

if errorlevel 1 (
  echo.
  echo Something needed your attention. Read the lines above, then run this again.
  pause
)
