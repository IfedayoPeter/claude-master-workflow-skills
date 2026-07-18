# Installs the master workflow skills + the SessionStart routing hook for the current user.
# Run from the repo root:  .\install.ps1
$ErrorActionPreference = "Stop"
$repo = $PSScriptRoot
$claudeDir = Join-Path $HOME ".claude"
$hookCommand = 'cat "$HOME/.claude/hooks/master-workflow-reminder.json"'

# 1. Skills
New-Item -ItemType Directory -Force (Join-Path $claudeDir "skills") | Out-Null
Copy-Item -Recurse -Force (Join-Path $repo "skills\*") (Join-Path $claudeDir "skills\")
Write-Host "Skills copied to $claudeDir\skills"

# 2. Hook payload
New-Item -ItemType Directory -Force (Join-Path $claudeDir "hooks") | Out-Null
Copy-Item -Force (Join-Path $repo "hooks\master-workflow-reminder.json") (Join-Path $claudeDir "hooks\")
Write-Host "Hook payload copied to $claudeDir\hooks"

# 3. Merge the SessionStart hook into ~/.claude/settings.json (idempotent)
# Written to run on BOTH Windows PowerShell 5.1 (what `powershell` launches on most Windows
# boxes) and PowerShell 7+ (`pwsh`). That rules out the ternary operator, pipeline-chain
# operators, and `ConvertFrom-Json -AsHashtable` (6.1+ only) — so we normalize the parsed JSON
# into a hashtable by hand and use only 5.1-safe syntax.
$settingsPath = Join-Path $claudeDir "settings.json"

function ConvertTo-HashtableDeep($obj) {
  if ($null -eq $obj) { return $null }
  if ($obj -is [System.Collections.IDictionary]) {
    $h = @{}
    foreach ($k in $obj.Keys) { $h[$k] = ConvertTo-HashtableDeep $obj[$k] }
    return $h
  }
  if ($obj -is [System.Management.Automation.PSCustomObject]) {
    $h = @{}
    foreach ($p in $obj.PSObject.Properties) { $h[$p.Name] = ConvertTo-HashtableDeep $p.Value }
    return $h
  }
  if ($obj -is [System.Collections.IEnumerable] -and $obj -isnot [string]) {
    return @($obj | ForEach-Object { ConvertTo-HashtableDeep $_ })
  }
  return $obj
}

if (Test-Path $settingsPath) {
  $raw = Get-Content $settingsPath -Raw
  $settings = if ([string]::IsNullOrWhiteSpace($raw)) { @{} } else { ConvertTo-HashtableDeep ($raw | ConvertFrom-Json) }
} else {
  $settings = @{}
}
if (-not $settings.ContainsKey("hooks")) { $settings["hooks"] = @{} }
if (-not $settings["hooks"].ContainsKey("SessionStart")) { $settings["hooks"]["SessionStart"] = @() }

$already = $false
foreach ($matcherEntry in @($settings["hooks"]["SessionStart"])) {
  foreach ($h in @($matcherEntry["hooks"])) {
    if ($h["command"] -like "*master-workflow-reminder.json*") { $already = $true }
  }
}
if ($already) {
  Write-Host "SessionStart hook already configured - skipped."
} else {
  # Rebuild the array explicitly so a single existing entry (which unwraps to a scalar) still
  # concatenates correctly on 5.1.
  $settings["hooks"]["SessionStart"] = @(@($settings["hooks"]["SessionStart"]) + @{
    hooks = @(@{
      type          = "command"
      command       = $hookCommand
      timeout       = 10
      statusMessage = "Loading master-workflow routing rules"
    })
  })
  $settings | ConvertTo-Json -Depth 20 | Set-Content $settingsPath -Encoding utf8
  Write-Host "SessionStart hook added to $settingsPath"
}

Write-Host ""
Write-Host "Done. Restart Claude Code (or start a new session) to activate the skills and the routing hook."
