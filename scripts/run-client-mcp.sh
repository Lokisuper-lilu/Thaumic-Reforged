#!/usr/bin/env bash
# Optional development control mod. No Gradle dependency or global Codex change.
set -euo pipefail
project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
name=minecraft-mcp-1.12.2-forge-v0.4.20.jar
expected=ca558950c834352e17ad62d75e18a7435a9a7fae5727d1136d5934ef9da94fc3
download="$project_dir/.tools/downloads/$name"
mkdir -p "$project_dir/.tools/downloads" "$project_dir/run/mods"
if [[ ! -f "$download" ]] || [[ $(sha256sum "$download" | cut -d' ' -f1) != "$expected" ]]; then
    curl --tls-max 1.2 --fail --location --retry 3 \
        "https://github.com/langyo/minecraft-mod-mcp/releases/download/v0.4.20/$name" -o "$download.part"
    printf '%s  %s\n' "$expected" "$download.part" | sha256sum --check
    mv -- "$download.part" "$download"
fi
printf '%s  %s\n' "$expected" "$download" | sha256sum --check
target="$project_dir/run/mods/$name"
created=false
if [[ -e "$target" ]]; then
    cmp -- "$download" "$target" || { printf '%s\n' 'A different MCP jar already exists; refusing to overwrite it.' >&2; exit 1; }
else
    cp -- "$download" "$target"
    created=true
fi
cleanup() { if "$created"; then rm -f -- "$target"; fi; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
export MC_MCP_BACKGROUND_INPUT=1
export MC_MCP_PORT="${MC_MCP_PORT:-9876}"
"$project_dir/scripts/gradle.sh" runClient "$@"
