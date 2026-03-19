#!/bin/bash
set -euo pipefail

plugin_dir="${NEO4J_server_directories_plugins:-/plugins}"
opengds_enabled="${ENABLE_OPENGDS:-true}"
opengds_version="${OPENGDS_VERSION:-2.12.0}"
opengds_jar="${plugin_dir}/opengds-${opengds_version}.jar"
opengds_url="https://dist.dozerdb.org/plugins/open-gds/open-gds-${opengds_version}.jar"

download_file() {
    local url="$1"
    local output="$2"
    local tmp_file

    tmp_file="$(mktemp "${output}.tmp.XXXXXX")"

    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$tmp_file"
    elif command -v wget >/dev/null 2>&1; then
        wget -q -O "$tmp_file" "$url"
    else
        echo "No download client found for ${url}" >&2
        exit 1
    fi

    mv "$tmp_file" "$output"
    chmod 0644 "$output"
}

echo "Running as: $(whoami)"
mkdir -p \
    "${NEO4J_server_directories_data:-/data}" \
    "${NEO4J_server_directories_logs:-/logs}" \
    "${NEO4J_server_directories_import:-/var/lib/neo4j/import}" \
    "$plugin_dir"

case "$opengds_enabled" in
    true|TRUE|1|yes|YES)
        if [ -f "$opengds_jar" ]; then
            echo "OpenGDS ${opengds_version} already present."
        else
            echo "Downloading OpenGDS ${opengds_version}..."
            download_file "$opengds_url" "$opengds_jar"
        fi
        ;;
    *)
        echo "Skipping OpenGDS download."
        ;;
esac

exec "$@"