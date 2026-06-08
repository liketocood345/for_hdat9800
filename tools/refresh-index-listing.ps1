# Rebuild docs/index.html post cards from docs/posts/posts.json (includes QMD-only posts).
# Run after sync-qmd-post-to-docs.ps1; do not run render_site() again or QMD docs are removed.

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$postsJsonPath = Join-Path (Join-Path "docs" "posts") "posts.json"
$indexPath = Join-Path "docs" "index.html"
if (-not (Test-Path $postsJsonPath)) { Write-Error "Missing $postsJsonPath" }
if (-not (Test-Path $indexPath)) { Write-Error "Missing $indexPath" }

function Format-PublishedDate([string]$isoDate) {
    $dt = [datetime]::ParseExact($isoDate, "yyyy-MM-dd", $null)
    return $dt.ToString("MMMM d, yyyy", [System.Globalization.CultureInfo]::InvariantCulture)
}

function Escape-Html([string]$text) {
    if ($null -eq $text) { return "" }
    return [System.Net.WebUtility]::HtmlEncode($text)
}

$posts = Get-Content $postsJsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
$posts = $posts | Sort-Object { [datetime]$_.date } -Descending

$cards = New-Object System.Text.StringBuilder
[void]$cards.AppendLine('<h1 class="posts-list-caption" data-caption="Overview">Overview</h1>')
foreach ($post in $posts) {
    $href = $post.path.TrimEnd('/') + '/'
    $dateLabel = Format-PublishedDate $post.date
    $authorName = ""
    if ($post.author -and $post.author.Count -gt 0 -and $post.author[0].name) {
        $authorName = Escape-Html $post.author[0].name
    }
    $authorBlock = ""
    if ($authorName) {
        $authorBlock = @"
<div class="dt-authors">
<div class="dt-author">$authorName</div>
</div>
"@
    }
    $title = Escape-Html $post.title
    $desc = Escape-Html $post.description
    [void]$cards.AppendLine(@"
<a href="$href" class="post-preview">
<script class="post-metadata" type="text/json">{"categories":[]}</script>
<div class="metadata">
<div class="publishedDate">$dateLabel</div>
$authorBlock
</div>
<div class="thumbnail">
<img/>
</div>
<div class="description">
<h2>$title</h2>
<div class="dt-tags"></div>
<p>$desc</p>
</div>
</a>
"@)
}

$html = Get-Content $indexPath -Raw -Encoding UTF8
$pattern = '(?s)(<div class="posts-list">).*?(</div>\s*<div class="posts-more">)'
if ($html -notmatch $pattern) {
    Write-Error "Could not locate posts-list block in $indexPath"
}
$replacement = '${1}' + [Environment]::NewLine + $cards.ToString().TrimEnd() + [Environment]::NewLine + '${2}'
$html = [regex]::Replace($html, $pattern, $replacement, 1)
Set-Content $indexPath $html -Encoding UTF8 -NoNewline
Write-Host "Refreshed listing in $indexPath from posts.json"
