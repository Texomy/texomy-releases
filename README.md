# Texomy releases

Native binaries of the `texomy` command line: `parse`, `test`, `check` and `mcp` (an MCP server over stdio).
Each release lists the files below and their checksums in `SHA256SUMS`. This repository holds releases only.

| Platform | File |
|---|---|
| macOS, Apple silicon | `texomy-macos-arm64.tar.gz` |
| Linux x64 | `texomy-linux-x64.tar.gz` |
| Linux arm64 | `texomy-linux-arm64.tar.gz` |
| Windows x64 | `texomy-windows-x64.zip` |

## Install

macOS (Apple silicon) and Linux (x64, arm64), with Homebrew:

```bash
brew install texomy/tap/texomy
```

or with the install script, which puts `texomy` in `~/.local/bin`:

```bash
curl -fsSL https://raw.githubusercontent.com/Texomy/texomy-releases/main/install.sh | sh
```

Windows (x64), in PowerShell; the script puts `texomy.exe` in `%LOCALAPPDATA%\Programs\texomy` and adds it to the
user's `PATH`:

```powershell
irm https://raw.githubusercontent.com/Texomy/texomy-releases/main/install.ps1 | iex
```

Both scripts check the download against `SHA256SUMS`. `TEXOMY_VERSION` picks a release (`v1.2.0`; default: the latest)
and `TEXOMY_INSTALL_DIR` the folder.

A file downloaded with a browser on macOS is blocked as unsigned: run `xattr -d com.apple.quarantine texomy` once.
Homebrew and the install script are not affected.
