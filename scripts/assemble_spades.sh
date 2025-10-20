#!/usr/bin/env bash
set -euo pipefail
R1=${1:-clean_R1.fq.gz}
R2=${2:-clean_R2.fq.gz}
OUT=${3:-spades_out}
spades.py -1 "$R1" -2 "$R2" -o "$OUT" --careful -t 4 -m 8
echo "SPAdes assembly at $OUT/contigs.fasta"

