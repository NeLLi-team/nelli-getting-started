#!/usr/bin/env bash
set -euo pipefail
FAA=${1:-data/examples/example.faa}
ALN=aln.faa
mafft --auto "$FAA" > "$ALN"
trimal -in "$ALN" -out aln.trim.faa -automated1
echo "Alignment at $ALN ; Trimmed at aln.trim.faa"

