<#
.SYNOPSIS
  Run Ansible commands using the repo's WSL virtualenv (UTF-8 Linux controller).

.PARAMETER Distro
  WSL distribution name as shown by: wsl -l -v (default: Ubuntu).

.EXAMPLE
  .\scripts\ansible-wsl.ps1 ansible --version
  .\scripts\ansible-wsl.ps1 -Distro Debian ansible-playbook -i inventory playbook.yml
  .\scripts\ansible-wsl.ps1 ansible-lint playbooks/
#>
param(
  [string]$Distro = "Ubuntu",
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$CommandArgs
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$winPath = $repoRoot.Path

# wslpath via wsl.exe can mangle backslashes from PowerShell; convert explicitly.
if ($winPath -notmatch '^([A-Za-z]):\\(.*)$') {
  Write-Error "Expected a drive-letter path (e.g. C:\...), got: $winPath"
}
$drive = $Matches[1].ToLower()
$rest = $Matches[2].Replace('\', '/')
$wslPath = "/mnt/$drive/$rest"

$activate = "set -e; source `"$wslPath/.venv-wsl/bin/activate`""
if (-not $CommandArgs -or $CommandArgs.Count -eq 0) {
  wsl.exe -d $Distro -e bash -lc "$activate; exec bash -l"
  exit $LASTEXITCODE
}

# Simple join; quote args that contain spaces.
$parts = foreach ($a in $CommandArgs) {
  if ($a -match '\s') { "'$($a -replace "'", "'\''")'" } else { $a }
}
$cmdLine = $parts -join ' '
wsl.exe -d $Distro -e bash -lc "$activate; $cmdLine"
