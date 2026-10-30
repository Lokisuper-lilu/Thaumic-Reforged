#!/usr/bin/env bash
# Keep the JDK, caches and optional proxy settings scoped to this project.
set -euo pipefail
project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
if [[ -n "${JAVA8_HOME:-}" ]]; then
    export JAVA_HOME="$JAVA8_HOME"
elif [[ -x "$project_dir/.tools/jdk8/bin/javac" ]]; then
    export JAVA_HOME="$project_dir/.tools/jdk8"
else
    export JAVA_HOME="${JAVA_HOME:-}"
fi
if [[ ! -x "$JAVA_HOME/bin/javac" ]] || ! "$JAVA_HOME/bin/java" -version 2>&1 | head -1 | grep -q '"1\.8\.'; then
    printf '%s\n' 'JDK 8 required. Set JAVA8_HOME, or run scripts/bootstrap-jdk8.sh on Linux x86_64.' >&2
    exit 1
fi
export PATH="$JAVA_HOME/bin:$PATH"
export GRADLE_USER_HOME="${GRADLE_USER_HOME:-$project_dir/.gradle-user-home}"
export JAVA_OPTS="${JAVA_OPTS:-} -Dfile.encoding=UTF-8 -Dhttps.protocols=TLSv1.2 -Djdk.tls.client.protocols=TLSv1.2"
# Gradle/Java do not automatically honor HTTPS_PROXY. Support local HTTP proxies;
# complex/authenticated proxies should be configured through Gradle properties.
proxy_url=${HTTPS_PROXY:-${https_proxy:-}}
if [[ "$proxy_url" =~ ^http://([a-zA-Z0-9.-]+):([0-9]+)/?$ ]]; then
    export JAVA_OPTS="$JAVA_OPTS -Dhttps.proxyHost=${BASH_REMATCH[1]} -Dhttps.proxyPort=${BASH_REMATCH[2]} -Dhttp.proxyHost=${BASH_REMATCH[1]} -Dhttp.proxyPort=${BASH_REMATCH[2]} -Dhttp.nonProxyHosts=localhost\|127.*\|\[::1\]"
fi
cd -- "$project_dir"
exec ./gradlew "$@"
