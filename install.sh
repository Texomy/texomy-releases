#!/bin/sh
# Installs the texomy command line on macOS (Apple silicon) or Linux (x64, arm64):
#   curl -fsSL https://raw.githubusercontent.com/Texomy/texomy-releases/main/install.sh | sh
# TEXOMY_VERSION picks a release (v1.2.0; default: the latest), TEXOMY_INSTALL_DIR the folder (default: ~/.local/bin).
set -eu

repository="https://github.com/Texomy/texomy-releases/releases"
version="${TEXOMY_VERSION:-latest}"
dir="${TEXOMY_INSTALL_DIR:-$HOME/.local/bin}"

fail() {
  echo "texomy: $1" >&2
  exit 1
}

case "$(uname -s)/$(uname -m)" in
  Darwin/arm64) platform=macos-arm64 ;;
  Darwin/x86_64) fail "macOS on Intel is not supported; texomy runs on Apple silicon." ;;
  Linux/x86_64 | Linux/amd64) platform=linux-x64 ;;
  Linux/aarch64 | Linux/arm64) platform=linux-arm64 ;;
  *) fail "$(uname -s) $(uname -m) is not supported. On Windows, run install.ps1 in PowerShell." ;;
esac

if [ "$version" = latest ]; then
  url="$repository/latest/download"
else
  url="$repository/download/$version"
fi
archive="texomy-$platform.tar.gz"

command -v curl > /dev/null || fail "curl is required."
temp=$(mktemp -d)
trap 'rm -rf "$temp"' EXIT

echo "Downloading $archive ($version)"
curl -fsSL "$url/$archive" -o "$temp/$archive" || fail "Cannot download $url/$archive."
curl -fsSL "$url/SHA256SUMS" -o "$temp/SHA256SUMS" || fail "Cannot download $url/SHA256SUMS."

expected=$(awk -v file="$archive" '$2 == file { print $1 }' "$temp/SHA256SUMS")
if command -v sha256sum > /dev/null; then
  actual=$(sha256sum "$temp/$archive" | awk '{ print $1 }')
else
  actual=$(shasum -a 256 "$temp/$archive" | awk '{ print $1 }')
fi
[ -n "$expected" ] && [ "$expected" = "$actual" ] || fail "The checksum of $archive does not match SHA256SUMS."

tar -xzf "$temp/$archive" -C "$temp"
mkdir -p "$dir"
mv "$temp/texomy" "$dir/texomy"
chmod +x "$dir/texomy"

echo "Installed $("$dir/texomy" --version) to $dir/texomy"
case ":$PATH:" in
  *":$dir:"*) ;;
  *) echo "Add $dir to your PATH, for example: echo 'export PATH=\"$dir:\$PATH\"' >> ~/.profile" ;;
esac
