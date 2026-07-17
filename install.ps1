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
$settingsPath = Join-Path $claudeDir "settings.json"
$settings = (Test-Path $settingsPath) `
  ? (Get-Content $settingsPath -Raw | ConvertFrom-Json -AsHashtable) `
  : @{}
if (-not $settings.ContainsKey("hooks")) { $settings["hooks"] = @{} }
if (-not $settings["hooks"].ContainsKey("SessionStart")) { $settings["hooks"]["SessionStart"] = @() }

$already = $false
foreach ($matcherEntry in $settings["hooks"]["SessionStart"]) {
  foreach ($h in $matcherEntry["hooks"]) {
    if ($h["command"] -like "*master-workflow-reminder.json*") { $already = $true }
  }
}
if ($already) {
  Write-Host "SessionStart hook already configured - skipped."
} else {
  $settings["hooks"]["SessionStart"] += @{
    hooks = @(@{
      type          = "command"
      command       = $hookCommand
      timeout       = 10
      statusMessage = "Loading master-workflow routing rules"
    })
  }
  $settings | ConvertTo-Json -Depth 20 | Set-Content $settingsPath -Encoding utf8
  Write-Host "SessionStart hook added to $settingsPath"
}

Write-Host ""
Write-Host "Done. Restart Claude Code (or start a new session) to activate the skills and the routing hook."
