#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Downloading reference test datasets..."
bash data/downloads.sh

echo "Generating mock reads for quick demos..."
bash scripts/make_mock_reads.sh

echo "Test data setup complete."
