param(
    [string]$SessionPath,
    [string]$KitPath = (Join-Path (Split-Path $PSScriptRoot -Parent) 'kit\news-image-20261117-kit'),
    [string]$BundlePath = (Join-Path $PSScriptRoot 'transcripts\entry-transcripts.tar.gz')
)
$ErrorActionPreference = 'Stop'
$cli = Join-Path $KitPath 'cli\makefun.mjs'
if (-not (Test-Path -LiteralPath $cli)) { throw "Missing official CLI: $cli" }

# Discovery reads only JSONL session metadata to locate this workspace's log.
if (-not $SessionPath) {
    $sessionRoot = Join-Path $env:USERPROFILE '.codex\sessions'
    $candidates = Get-ChildItem -LiteralPath $sessionRoot -Filter '*.jsonl' -File -Recurse |
        Sort-Object LastWriteTime -Descending
    foreach ($candidate in $candidates) {
        $firstLine = Get-Content -LiteralPath $candidate.FullName -Encoding UTF8 -TotalCount 1 | ConvertFrom-Json
        if ($firstLine.type -eq 'session_meta' -and $firstLine.payload.cwd -eq $PSScriptRoot) {
            $SessionPath = $candidate.FullName
            break
        }
    }
}
if (-not $SessionPath) { throw 'No genuine session found. Pass -SessionPath with the actual Codex JSONL log.' }

$records = @(Get-Content -LiteralPath $SessionPath -Encoding UTF8 | ForEach-Object { $_ | ConvertFrom-Json })
$metadata = ($records | Where-Object type -eq 'session_meta' | Select-Object -First 1).payload
$context = ($records | Where-Object type -eq 'turn_context' | Select-Object -Last 1).payload
$mission = $null
foreach ($record in $records) {
    if ($record.type -ne 'response_item' -or $record.payload.role -ne 'user') { continue }
    foreach ($part in $record.payload.content) {
        if ($part.text -and $part.text.StartsWith('You are my autonomous senior coding agent,')) {
            $mission = $part.text
            break
        }
    }
    if ($mission) { break }
}
if (-not $mission) { throw 'The original user mission is not present in the selected log.' }
if (-not $metadata.cli_version -or -not $context.model -or -not $context.effort) {
    throw 'Harness version, model or effort is missing; do not invent it.'
}

$local = Join-Path $PSScriptRoot '.local'
New-Item -ItemType Directory -Path $local -Force | Out-Null
New-Item -ItemType Directory -Path (Split-Path $BundlePath -Parent) -Force | Out-Null
$promptPath = Join-Path $local 'original-mission.txt'
# The mission file is run-record metadata, not a replacement transcript.
[System.IO.File]::WriteAllText($promptPath, $mission, [System.Text.UTF8Encoding]::new($false))
$bundleArgs = @(
    $cli, 'bundle', '--repo', $PSScriptRoot, '--out', $BundlePath,
    '--no-discover', '--session', $SessionPath,
    '--no-context', '--instructions',
    'withheld:Instruction files are not separately uploaded; recorded session setup is retained unchanged.',
    '--harness', 'codex', '--harness-version', $metadata.cli_version,
    '--provider', 'openai', '--model', $context.model, '--effort', $context.effort,
    '--prompt-file', $promptPath, '--prompt-origin', 'other', '--prompt-via',
    'The user supplied this mission in the same recorded conversation after its initial unresolved documentPrompt placeholder.',
    '--mcp', 'codex_apps=builtin', '--json'
)
# The official bundler alone redacts its copies. Never alter the source log.
& node @bundleArgs
if ($LASTEXITCODE -ne 0) { throw "Official bundle failed: $LASTEXITCODE" }
Write-Output "Genuine transcript bundle: $BundlePath"
