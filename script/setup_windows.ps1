param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$rootDir = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$hostHome = if ($env:USERPROFILE) { $env:USERPROFILE } else { $env:HOME }
$localAppData = $env:LOCALAPPDATA

if (-not $hostHome) {
    throw "USERPROFILE and HOME are both empty. This script is intended for Windows."
}

if (-not $localAppData) {
    throw "LOCALAPPDATA is empty. This script is intended for native Windows Neovim."
}

$dirsToCreate = @(
    (Join-Path $rootDir 'data\.config\nvim'),
    (Join-Path $rootDir 'data\.local\share\nvim'),
    (Join-Path $rootDir 'data\.local\state\nvim'),
    (Join-Path $rootDir 'data\.cache\nvim'),
    (Join-Path $rootDir 'host')
)

foreach ($dir in $dirsToCreate) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

function Ensure-Directory($path) {
    if (-not (Test-Path -LiteralPath $path)) {
        New-Item -ItemType Directory -Force -Path $path | Out-Null
    }
}

function Ensure-Link {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination,
        [Parameter(Mandatory = $true)][ValidateSet('dir', 'file')][string]$Kind
    )

    $srcFull = (Resolve-Path -LiteralPath $Source).Path
    $dstFull = $Destination

    if (Test-Path -LiteralPath $dstFull) {
        $item = Get-Item -LiteralPath $dstFull -Force
        if ($item.LinkType -and $item.LinkType -eq 'Junction' -or $item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            $existingTarget = if ($item.LinkType -eq 'Junction') { $item.Target } else { (Get-Item -LiteralPath $dstFull).Target }
            if ($existingTarget -and ((Resolve-Path -LiteralPath $existingTarget).Path -eq $srcFull)) {
                Write-Host "[ok] $dstFull already points to $srcFull"
                return
            }
        }

        if (-not $Force) {
            $answer = Read-Host "$dstFull already exists. Overwrite it? [y/N]"
            if ($answer -notmatch '^[Yy]$') {
                Write-Host "[skip] $dstFull`: leaving it unchanged"
                return
            }
        }

        $backup = "$dstFull.bak.$((Get-Date).ToString('yyyyMMdd-HHmmss'))"
        Move-Item -LiteralPath $dstFull -Destination $backup -Force
        Write-Host "[backup] $dstFull -> $backup"
    }

    Ensure-Directory (Split-Path -Parent $dstFull)

    if ($Kind -eq 'dir') {
        New-Item -ItemType Junction -Path $dstFull -Target $srcFull | Out-Null
    }
    else {
        New-Item -ItemType SymbolicLink -Path $dstFull -Target $srcFull | Out-Null
    }

    Write-Host "[link] $dstFull -> $srcFull"
}

Ensure-Directory $hostHome
Ensure-Directory (Join-Path $hostHome '.config')
Ensure-Directory (Join-Path $hostHome '.local\share')
Ensure-Directory (Join-Path $hostHome '.local\state')
Ensure-Directory (Join-Path $hostHome '.cache')

Ensure-Link -Source (Join-Path $rootDir 'host') -Destination (Join-Path $hostHome 'host') -Kind dir
Ensure-Link -Source (Join-Path $rootDir 'data\.config\nvim') -Destination (Join-Path $localAppData 'nvim') -Kind dir
Ensure-Link -Source (Join-Path $rootDir 'data\.local\share\nvim') -Destination (Join-Path $localAppData 'nvim-data') -Kind dir
Ensure-Link -Source (Join-Path $rootDir 'data\.local\state\nvim') -Destination (Join-Path $localAppData 'nvim-data\nvim') -Kind dir
Ensure-Link -Source (Join-Path $rootDir 'data\.cache\nvim') -Destination (Join-Path $env:TEMP 'nvim') -Kind dir
Ensure-Link -Source (Join-Path $rootDir 'data\.gitconfig') -Destination (Join-Path $hostHome '.gitconfig') -Kind file
Ensure-Link -Source (Join-Path $rootDir 'data\.bashrc') -Destination (Join-Path $hostHome '.bashrc') -Kind file
Ensure-Link -Source (Join-Path $rootDir 'data\.tmux.conf') -Destination (Join-Path $hostHome '.tmux.conf') -Kind file
Ensure-Link -Source (Join-Path $rootDir 'data\.stylua.toml') -Destination (Join-Path $hostHome '.stylua.toml') -Kind file

Write-Host ""
Write-Host "[ok] Windows host setup completed."
Write-Host ""
Write-Host "Project root: $rootDir"
Write-Host "Host home: $hostHome"
Write-Host ""
Write-Host "Equivalent paths:"
Write-Host "  $hostHome\host -> $rootDir\host"
Write-Host "  $localAppData\nvim -> $rootDir\data\.config\nvim"
Write-Host "  $localAppData\nvim-data -> $rootDir\data\.local\share\nvim"
Write-Host "  $localAppData\nvim-data\nvim -> $rootDir\data\.local\state\nvim"
Write-Host "  $env:TEMP\nvim -> $rootDir\data\.cache\nvim"
Write-Host "  $hostHome\.gitconfig -> $rootDir\data\.gitconfig"
Write-Host "  $hostHome\.bashrc -> $rootDir\data\.bashrc"
Write-Host "  $hostHome\.tmux.conf -> $rootDir\data\.tmux.conf"
Write-Host "  $hostHome\.stylua.toml -> $rootDir\data\.stylua.toml"
