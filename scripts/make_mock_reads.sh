#!/usr/bin/env bash
set -euo pipefail
IN="data/examples/example.fna"
OUTDIR="data/mock"
mkdir -p "$OUTDIR"

# create 50k paired reads @150bp from two contigs with 1% error and 0.5% indels
"$(dirname "$0")/run_bbtools.sh" randomreads.sh ref="$IN" out1="$OUTDIR/mock_R1.fq.gz" out2="$OUTDIR/mock_R2.fq.gz" \
    len=150 paired snprate=0.01 insrate=0.002 delrate=0.003 coverage=50
echo "Mock reads written to $OUTDIR/"
