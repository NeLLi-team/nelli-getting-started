#!/usr/bin/env bash
set -euo pipefail
FAA=${1:-data/examples/example.faa}
diamond makedb --in "$FAA" -d prot
diamond cluster --db prot --out clusters_diamond.tsv --linclust --min-id 0.9
echo "DIAMOND clusters at clusters_diamond.tsv"

