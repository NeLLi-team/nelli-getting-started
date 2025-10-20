#!/usr/bin/env bash
set -euo pipefail
R1=${1:-data/mock/mock_R1.fq.gz}
R2=${2:-data/mock/mock_R2.fq.gz}
ASM=${3:-data/examples/example.fna}

# QC
"$(dirname "$0")/run_bbtools.sh" bbduk.sh in="$R1" in2="$R2" out1=clean_R1.fq.gz out2=clean_R2.fq.gz \
    ref=adapters ktrim=r k=23 mink=11 hdist=1 tpe tbo

# Map to assembly
"$(dirname "$0")/run_bbtools.sh" bbmap.sh ref="$ASM" in=clean_R1.fq.gz in2=clean_R2.fq.gz out=mapped.sam
samtools view -bS mapped.sam | samtools sort -o mapped.bam
samtools index mapped.bam

# Depth per contig for binning
jgi_summarize_bam_contig_depths --outputDepth depth.txt mapped.bam
echo "QC+map done: clean_* fastq, mapped.bam, depth.txt"
