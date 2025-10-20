#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

IMAGE="${BBTOOLS_IMAGE:-bryce911/bbtools:latest}"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <bbtools-command> [args...]" >&2
    exit 64
fi

CMD="$1"
shift

if command -v "$CMD" >/dev/null 2>&1; then
    exec "$CMD" "$@"
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "docker is required to run $CMD via container." >&2
    exit 127
fi

docker run --rm \
    -v "$ROOT_DIR":/work \
    -w /work \
    "$IMAGE" \
    "$CMD" "$@"
