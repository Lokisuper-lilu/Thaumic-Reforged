#!/usr/bin/env bash
# Official Eclipse Temurin binary, pinned and verified against Adoptium metadata.
set -euo pipefail
project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
if [[ $(uname -s) != Linux || $(uname -m) != x86_64 ]]; then
    printf '%s\n' 'This bootstrap supports Linux x86_64. Install JDK 8 for your OS and set JAVA8_HOME.' >&2
    exit 1
fi
archive=OpenJDK8U-jdk_x64_linux_hotspot_8u504b01.tar.gz
expected=9c70e102f527ac674ac2fe9c7d47b9a04e2d19842ba5ab8e9b33f368bbadfaea
mkdir -p "$project_dir/.tools/downloads"
cd -- "$project_dir/.tools/downloads"
if [[ ! -f "$archive" ]] || [[ $(sha256sum "$archive" | cut -d' ' -f1) != "$expected" ]]; then
    curl --tls-max 1.2 --fail --location --retry 3 \
        "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u504-b01/$archive" -o "$archive.part"
    printf '%s  %s\n' "$expected" "$archive.part" | sha256sum --check
    mv -- "$archive.part" "$archive"
fi
printf '%s  %s\n' "$expected" "$archive" | sha256sum --check
if [[ ! -d "$project_dir/.tools/jdk8" ]]; then
    mkdir -p "$project_dir/.tools/jdk8"
    tar -xzf "$archive" --strip-components=1 -C "$project_dir/.tools/jdk8"
fi
"$project_dir/.tools/jdk8/bin/java" -version
"$project_dir/.tools/jdk8/bin/javac" -version
