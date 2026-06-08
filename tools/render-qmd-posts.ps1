# Render Quarto (.qmd) blog posts under _posts/.
# Distill Rmd pages (index.Rmd, about.Rmd) still use rmarkdown::render_site().
#
# Usage:
#   powershell -File tools/render-qmd-posts.ps1                 # skip draft: true
#   powershell -File tools/render-qmd-posts.ps1 -IncludeDrafts  # include drafts (local preview)
#   powershell -File tools/render-qmd-posts.ps1 -PostPath "_posts/.../file.qmd"

param(
    [switch]$IncludeDrafts,
    [string]$PostPath = ""
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

if (-not (Get-Command quarto -ErrorAction SilentlyContinue)) {
    Write-Error "Quarto CLI not found. Install: winget install Posit.Quarto"
}

function Test-DraftPost {
    param([string]$File)
    $head = Get-Content $File -TotalCount 30 -Encoding UTF8
    return ($head -match '^\s*draft:\s*true\s*$')
}

function Get-QmdPosts {
    if ($PostPath) {
        return @(Resolve-Path $PostPath)
    }
    return Get-ChildItem -Path "_posts" -Recurse -Filter "*.qmd" -File |
        Where-Object { $_.Name -notmatch '^_' }
}

$posts = Get-QmdPosts
if ($posts.Count -eq 0) {
    Write-Host "No .qmd posts found."
    exit 0
}

foreach ($post in $posts) {
    $isDraft = Test-DraftPost $post.FullName
    if ($isDraft -and -not $IncludeDrafts) {
        Write-Host "[skip draft] $($post.FullName)"
        continue
    }
    Write-Host "[render] $($post.FullName)"
    $prevEap = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    & quarto render $post.FullName 2>&1 | ForEach-Object { "$_" }
    $exit = $LASTEXITCODE
    $ErrorActionPreference = $prevEap
    if ($exit -ne 0) {
        throw "quarto render failed for $($post.FullName) (exit $exit)"
    }
}

Write-Host "Done."
