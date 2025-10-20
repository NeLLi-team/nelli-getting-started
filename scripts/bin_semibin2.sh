#!/usr/bin/env bash
set -euo pipefail
ASM=${1:-spades_out/contigs.fasta}
R1=${2:-clean_R1.fq.gz}
R2=${3:-clean_R2.fq.gz}
outdir=semibin2_out
SemiBin2 single_easy_bin -i "$ASM" -r "$R1" "$R2" -o "$outdir"
echo "SemiBin2 output in $outdir/"

