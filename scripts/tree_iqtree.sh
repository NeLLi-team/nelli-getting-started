#!/usr/bin/env bash
set -euo pipefail
ALN=${1:-aln.trim.faa}
iqtree2 -s "$ALN" -m MFP -B 1000 -T AUTO
echo "IQ-TREE outputs *.iqtree *.treefile etc."

