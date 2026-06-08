# Site build: rmarkdown::render_site() (Rmd + QMD posts with output: distill::distill_article).
#
# Usage:
#   powershell -File tools/build-website.ps1

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

if (-not (Get-Command Rscript -ErrorAction SilentlyContinue)) {
    Write-Warning "Rscript not on PATH — skip build. Run from RStudio or add R to PATH."
    exit 0
}

Write-Host "[render_site] rmarkdown::render_site()"
Rscript -e "setwd('.'); rmarkdown::render_site()"

Write-Host "Build complete."
