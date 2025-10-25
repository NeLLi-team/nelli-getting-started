#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="data/downloads"
mkdir -p "$DATA_DIR"

# CAMI II toy human microbiome short reads (tiny example dataset)
fetch() {
  local url="$1"
  local dest="$2"
  if [[ -s "$dest" ]]; then
    echo "✔ $dest already present; skipping download."
    return
  fi
  echo "⇢ Downloading $(basename "$dest")"
  curl -L "$url" -o "$dest"
}

fetch "https://zenodo.org/records/15083711/files/cami2_toy_R1.fastq.gz?download=1" \
      "$DATA_DIR/cami2_toy_R1.fastq.gz"
fetch "https://zenodo.org/records/15083711/files/cami2_toy_R2.fastq.gz?download=1" \
      "$DATA_DIR/cami2_toy_R2.fastq.gz"

echo "Fetched CAMI II toy reads to $DATA_DIR"

# MBARC-26 metadata pointer for SRA retrieval (requires sra-tools or fasterq-dump)
cat <<'SRA' > "$DATA_DIR/MBARC26_accessions.txt"
SRR4052715
SRR4052716
SRA

echo "Stored MBARC-26 accession list in $DATA_DIR/MBARC26_accessions.txt"
