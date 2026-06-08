# Hybrid site build: Quarto QMD posts (non-draft) + Distill render_site for Rmd.
#
# Usage:
#   powershell -File tools/build-website.ps1
#
# Draft QMD posts (draft: true in YAML) are skipped unless you pass -IncludeDrafts to render-qmd-posts.

param(
    [switch]$IncludeDrafts
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

if ($IncludeDrafts) {
    & (Join-Path $PSScriptRoot "render-qmd-posts.ps1") -IncludeDrafts
} else {
    & (Join-Path $PSScriptRoot "render-qmd-posts.ps1")
}

if (-not (Get-Command Rscript -ErrorAction SilentlyContinue)) {
    Write-Warning "Rscript not on PATH — skip rmarkdown::render_site(). Run from RStudio or add R to PATH."
    exit 0
}

Write-Host "[render_site] rmarkdown::render_site()"
Rscript -e "setwd('.'); rmarkdown::render_site()"

# Sync published QMD posts after render_site (Distill rebuilds docs/posts from Rmd only).
$syncedQmd = $false
Get-ChildItem "_posts" -Directory | ForEach-Object {
    $qmd = Get-ChildItem $_.FullName -Filter "*.qmd" -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notmatch '^_' } | Select-Object -First 1
    if (-not $qmd) { return }
    $head = Get-Content $qmd.FullName -TotalCount 30 -Encoding UTF8
    if ($head -match '^\s*draft:\s*true\s*$') { return }
    & (Join-Path $PSScriptRoot "sync-qmd-post-to-docs.ps1") -PostDir $_.FullName
    $script:syncedQmd = $true
}

if ($syncedQmd) {
    & (Join-Path $PSScriptRoot "refresh-index-listing.ps1")
}

Write-Host "Build complete."
