#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

step() {
    local no="$1"; shift
    local msg="$*"
    echo "[demo] Step $no: $msg"
}

step "1/8" "Generating mock reads"
bash scripts/make_mock_reads.sh

step "2/8" "Running read QC and mapping"
bash scripts/qc_map.sh

step "3/8" "Assembling with SPAdes"
bash scripts/assemble_spades.sh

step "4/8" "Binning with MetaBAT2"
bash scripts/bin_metabat2.sh

step "5/8" "Normalising FASTA headers"
python scripts/normalize_headers.py -i data/examples/example.faa -o example.norm.faa --genome-id DEMO

step "6/8" "Building alignment with MAFFT"
bash scripts/align_mafft.sh example.norm.faa

step "7/8" "Inferring ML tree with IQ-TREE"
bash scripts/tree_iqtree.sh aln.trim.faa

step "8/8" "Clustering proteins with MMseqs2"
bash scripts/cluster_mmseqs2.sh example.norm.faa

echo "[demo] Finished. Outputs in spades_out/, bins_metabat2/, aln.trim.faa, clusters.tsv."
