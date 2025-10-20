#!/usr/bin/env bash
set -euo pipefail
bash scripts/make_mock_reads.sh
bash scripts/qc_map.sh
bash scripts/assemble_spades.sh
bash scripts/bin_metabat2.sh
python scripts/normalize_headers.py -i data/examples/example.faa -o example.norm.faa --genome-id DEMO
bash scripts/align_mafft.sh example.norm.faa
bash scripts/tree_iqtree.sh aln.trim.faa
bash scripts/cluster_mmseqs2.sh example.norm.faa
echo "Demo finished."

