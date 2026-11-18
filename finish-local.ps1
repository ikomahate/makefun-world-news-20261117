param([string]$KitPath = (Join-Path (Split-Path $PSScriptRoot -Parent) 'kit\news-image-20261117-kit'))
$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
    & node .\verify.mjs
    if ($LASTEXITCODE -ne 0) { throw 'Image verification failed.' }
    # Local attribution only. No GitHub login or persistent Git config change.
    $tracked = @(
        '.gitignore', 'LICENSE', 'PUBLICATION.md', 'README.md', 'RESEARCH.md',
        'VALIDATION.md', 'bundle-transcripts.ps1', 'entry.png', 'finish-local.ps1',
        'main.ts', 'render.ps1', 'verify.mjs'
    )
    & git add -- @tracked
    if ($LASTEXITCODE -ne 0) { throw 'Git metadata is still read-only; run this in an unrestricted local PowerShell terminal.' }
    & git -c user.name=ikomahate -c user.email=ikomahate@users.noreply.github.com commit -m 'Build verified 17 November world news infographic'
    if ($LASTEXITCODE -ne 0) { throw 'Commit failed; inspect git status before continuing.' }
    $entryCommit = & git rev-parse HEAD
    Write-Output "Committed entry: $entryCommit"
    & powershell -NoProfile -ExecutionPolicy Bypass -File .\bundle-transcripts.ps1 -KitPath $KitPath
    if ($LASTEXITCODE -ne 0) { throw 'Transcript bundling failed.' }
    & node (Join-Path $KitPath 'cli\makefun.mjs') check --kit $KitPath --repo . --transcripts .\transcripts\entry-transcripts.tar.gz
    if ($LASTEXITCODE -ne 0) { throw 'Official checks failed.' }
    & git status --short
    Write-Output "Final local commit: $entryCommit"
    Write-Output 'Local handoff complete. Nothing was published, submitted, signed or paid.'
} finally {
    Pop-Location
}
