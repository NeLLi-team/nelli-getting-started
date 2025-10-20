#!/usr/bin/env bash
set -euo pipefail
FAA=${1:-data/examples/example.faa}
mmseqs createdb "$FAA" db
mmseqs linclust db db_clu tmp --min-seq-id 0.9 -c 0.8 --cov-mode 1
mmseqs createtsv db db db_clu clusters.tsv
echo "clusters.tsv written"

