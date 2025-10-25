#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[setup] Checking prerequisites (curl, bash)..."
command -v curl >/dev/null 2>&1 || { echo "curl is required" >&2; exit 127; }

echo "[setup] Downloading reference test datasets..."
bash data/downloads.sh

echo "[setup] Generating mock reads for quick demos..."
bash scripts/make_mock_reads.sh

echo "[setup] Test data setup complete."
