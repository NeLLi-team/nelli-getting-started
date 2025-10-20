#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Downloading reference test datasets..."
bash data/downloads.sh

echo "Generating mock reads for quick demos..."
if command -v randomreads.sh >/dev/null 2>&1; then
    bash scripts/make_mock_reads.sh
else
    echo "randomreads.sh not found on PATH; running via pixi."
    pixi run bash scripts/make_mock_reads.sh
fi

echo "Test data setup complete."
