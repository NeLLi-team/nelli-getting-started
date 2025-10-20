#!/usr/bin/env bash
set -euo pipefail
ASM=${1:-spades_out/contigs.fasta}
DEPTH=${2:-depth.txt}
outdir=bins_metabat2 && mkdir -p "$outdir"
metabat2 -i "$ASM" -a "$DEPTH" -o "$outdir/bin"
echo "MetaBAT2 bins in $outdir/"

