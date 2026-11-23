# Installs the texomy command line on Windows (x64):
#   irm https://raw.githubusercontent.com/Texomy/texomy-releases/main/install.ps1 | iex
# $env:TEXOMY_VERSION picks a release (v1.2.0; default: the latest), $env:TEXOMY_INSTALL_DIR the folder
# (default: %LOCALAPPDATA%\Programs\texomy). The folder is added to the user's PATH.
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$repository = 'https://github.com/Texomy/texomy-releases/releases'
$version = if ($env:TEXOMY_VERSION) { $env:TEXOMY_VERSION } else { 'latest' }
$dir = if ($env:TEXOMY_INSTALL_DIR) { $env:TEXOMY_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA 'Programs\texomy' }

if ($env:PROCESSOR_ARCHITECTURE -ne 'AMD64') {
    throw "texomy: Windows on $env:PROCESSOR_ARCHITECTURE is not supported; texomy runs on x64."
}
$url = if ($version -eq 'latest') { "$repository/latest/download" } else { "$repository/download/$version" }
$archive = 'texomy-windows-x64.zip'

$temp = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $temp | Out-Null
try {
    Write-Host "Downloading $archive ($version)"
    Invoke-WebRequest -UseBasicParsing "$url/$archive" -OutFile (Join-Path $temp $archive)
    Invoke-WebRequest -UseBasicParsing "$url/SHA256SUMS" -OutFile (Join-Path $temp 'SHA256SUMS')

    $expected = Get-Content (Join-Path $temp 'SHA256SUMS') |
        ForEach-Object { $parts = $_ -split '\s+'; if ($parts[1] -eq $archive) { $parts[0] } }
    $actual = (Get-FileHash -Algorithm SHA256 (Join-Path $temp $archive)).Hash.ToLower()
    if (-not $expected -or $expected -ne $actual) {
        throw "texomy: the checksum of $archive does not match SHA256SUMS."
    }

    Expand-Archive -Path (Join-Path $temp $archive) -DestinationPath $temp
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Move-Item -Force (Join-Path $temp 'texomy.exe') (Join-Path $dir 'texomy.exe')
} finally {
    Remove-Item -Recurse -Force $temp
}

$installed = & (Join-Path $dir 'texomy.exe') --version
Write-Host "Installed $installed to $dir\texomy.exe"

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (-not (($userPath -split ';') -contains $dir)) {
    [Environment]::SetEnvironmentVariable('Path', ($(if ($userPath) { "$userPath;" }) + $dir), 'User')
    Write-Host "Added $dir to your PATH; open a new terminal to use texomy."
}
