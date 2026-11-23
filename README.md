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

macOS or Linux, latest release:

```bash
curl -fsSL https://github.com/Texomy/texomy-releases/releases/latest/download/texomy-macos-arm64.tar.gz | tar -xz
sudo mv texomy /usr/local/bin/
texomy --version
```

Use the file for your platform. A file downloaded with `curl` runs as is. A file downloaded with a browser on
macOS is blocked as unsigned: run `xattr -d com.apple.quarantine texomy` once.

Windows: unpack `texomy-windows-x64.zip` and put `texomy.exe` on your `PATH`.
