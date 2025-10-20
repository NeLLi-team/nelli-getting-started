#!/usr/bin/env bash
set -euo pipefail
R1=${1:-clean_R1.fq.gz}
R2=${2:-clean_R2.fq.gz}
tadpole.sh in="$R1" in2="$R2" out=contigs_tadpole.fna mode=contig
echo "Tadpole contigs: contigs_tadpole.fna"

