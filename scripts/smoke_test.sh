#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TOTAL_STEPS=6
CURRENT=0

log() {
    local message="$1"
    printf '\n[smoke] %s\n' "$message"
}

next_step() {
    CURRENT=$((CURRENT + 1))
    log "[$CURRENT/$TOTAL_STEPS] $1"
}

trap 'echo "[smoke] ❌ Failed during step $CURRENT. Inspect the logs above for details."' ERR

next_step "Ensuring pixi environment is solved"
if command -v pixi >/dev/null 2>&1; then
    pixi install --locked
else
    log "pixi binary not on PATH; assuming you invoked the smoke test from an active pixi shell."
fi

next_step "Checking Docker availability for BBTools"
if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is required for BBTools fallback. Install Docker or provide native BBTools binaries." >&2
    exit 127
fi
docker info >/dev/null 2>&1 || {
    echo "Unable to talk to the Docker daemon. Start Docker and retry." >&2
    exit 125
}

next_step "Syncing example datasets and mock reads"
bash scripts/setup_test_data.sh

next_step "Verifying key CLI tools are on PATH"
missing=()
for cmd in samtools spades.py metabat2 mmseqs mafft trimal; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        missing+=("$cmd")
    fi
done
if ! command -v iqtree2 >/dev/null 2>&1 && ! command -v iqtree >/dev/null 2>&1; then
    missing+=("iqtree2/iqtree")
fi
if [[ ${#missing[@]} -gt 0 ]]; then
    printf 'Missing required tools: %s\n' "${missing[*]}" >&2
    exit 127
fi

next_step "Running end-to-end demo pipeline"
bash scripts/demo_all.sh

next_step "Spot-checking outputs"
ls -1 \
  spades_out/contigs.fasta \
  bins_metabat2 \
  aln.trim.faa \
  example.norm.faa \
  clusters.tsv

log "Smoke test completed successfully."
