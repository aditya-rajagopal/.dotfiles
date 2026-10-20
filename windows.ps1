[CmdletBinding()]
param(
    [string]$TargetHome = $env:USERPROFILE,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if ([string]::IsNullOrWhiteSpace($TargetHome) -or -not [IO.Path]::IsPathRooted($TargetHome)) {
    throw 'TargetHome must be an absolute path.'
}

# Resolve sources relative to this script, regardless of the shell's working directory.
$RepoRoot = $PSScriptRoot
$Items = @(
    @{ Source = 'nvim'; Destination = 'AppData\Local\nvim'; Directory = $true },
    @{ Source = '.glzr'; Destination = '.glzr'; Directory = $true },
    @{ Source = '.wezterm.lua'; Destination = '.wezterm.lua'; Directory = $false },
    @{ Source = '.ai\AGENTS.md'; Destination = '.codex\AGENTS.md'; Directory = $false },
    @{ Source = '.ai\AGENTS.md'; Destination = '.config\opencode\AGENTS.md'; Directory = $false },
    @{ Source = '.ai\skills'; Destination = '.codex\skills'; Directory = $true },
    @{ Source = '.ai\skills'; Destination = '.config\opencode\skills'; Directory = $true }
)
function Get-Entry([string]$Path) {
    # Enumerating the parent also finds dangling links on Windows PowerShell 5.1.
    $Parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $Parent -PathType Container)) { return $null }
    $Leaf = Split-Path -Leaf $Path
    return Get-ChildItem -LiteralPath $Parent -Force | Where-Object { $_.Name -eq $Leaf } | Select-Object -First 1
}

function Install-Link([string]$Source, [string]$Destination, [string]$BackupBase, [bool]$Directory) {
    $Existing = Get-Entry $Destination
    # The destination may be the source itself through a linked parent directory.
    if ($null -ne $Existing -and [IO.Path]::GetFullPath($Destination) -eq $Source) { return }
    if ($null -ne $Existing -and $Existing.LinkType -in @('SymbolicLink', 'Junction')) {
        $LinkTarget = @($Existing.Target)[0]
        if ($LinkTarget) {
            if (-not [IO.Path]::IsPathRooted($LinkTarget)) {
                $LinkTarget = Join-Path (Split-Path -Parent $Destination) $LinkTarget
            }
            if ([IO.Path]::GetFullPath($LinkTarget).TrimEnd('\', '/') -eq $Source.TrimEnd('\', '/')) {
                Write-Host "Already linked: $Destination"
                return
            }
        }
    }
    if ($DryRun) {
        $Action = if ($null -ne $Existing) { 'Back up and link' } else { 'Link' }
        Write-Host "${Action}: $Destination -> $Source"
        return
    }
    $Parent = Split-Path -Parent $Destination
    New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    $Backup = $null
    if ($null -ne $Existing) {
        for ($Index = 0; $Index -lt 1000; $Index++) {
            $Candidate = "$BackupBase.$Index"
            if ($null -eq (Get-Entry $Candidate)) { $Backup = $Candidate; break }
        }
        if ($null -eq $Backup) { throw "No free backup slot for $Destination" }
        New-Item -ItemType Directory -Path (Split-Path -Parent $Backup) -Force | Out-Null
        Move-Item -LiteralPath $Destination -Destination $Backup
        Write-Host "Preserved $Destination as $Backup"
    }
    try {
        # Junctions work without Developer Mode or elevation; file symlinks require one of them.
        $LinkType = if ($Directory) { 'Junction' } else { 'SymbolicLink' }
        New-Item -ItemType $LinkType -Path $Destination -Target $Source | Out-Null
    } catch {
        if ($null -ne $Backup -and $null -eq (Get-Entry $Destination)) {
            Move-Item -LiteralPath $Backup -Destination $Destination
        }
        throw "Cannot link $Destination. File symlinks require Developer Mode or an elevated shell. $($_.Exception.Message)"
    }
    Write-Host "Linked $Destination -> $Source"
}

# Preflight prevents a missing repository entry from causing a partial installation.
foreach ($Item in $Items) {
    $Source = Join-Path $RepoRoot $Item.Source
    $ExpectedType = if ($Item.Directory) { 'Container' } else { 'Leaf' }
    if (-not (Test-Path -LiteralPath $Source -PathType $ExpectedType)) {
        throw "Missing source or unexpected type: $Source"
    }
}
foreach ($Item in $Items) {
    Install-Link -Source (Join-Path $RepoRoot $Item.Source) `
        -Destination (Join-Path $TargetHome $Item.Destination) `
        -BackupBase (Join-Path (Join-Path $TargetHome '.dotfiles-backups') $Item.Destination) `
        -Directory $Item.Directory
}
