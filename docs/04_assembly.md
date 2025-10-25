# Assembly Strategies

## Objectives
- Turn quality-controlled reads into contigs with minimal fragmentation.
- Generate assemblies that balance contiguity (N50) with accuracy (low misassembly rate).

## SPAdes (Default)

SPAdes performs well on the toy dataset and most short-read metagenomes we process during onboarding.

```bash
spades.py \
  -1 clean_R1.fq.gz \
  -2 clean_R2.fq.gz \
  -o spades_out \
  --careful \
  -t 8 \
  -m 32
```

- `--careful` reduces mismatches/indels at the cost of runtime.
- Adjust `-t` (threads) and `-m` (RAM in GB) to suit your workstation; the toy dataset fits in <2 GB, but the flags document realistic defaults for production runs.
- Output contigs live in `spades_out/contigs.fasta`, with useful QC summaries in `spades_out/contigs.paths` and `spades_out/spades.log`.

## Tadpole (BBTools)

Tadpole is a fast k-mer assembler bundled with BBTools—handy when you only need a quick draft assembly or want a second opinion.

```bash
bash scripts/run_bbtools.sh tadpole.sh \
  in=clean_R1.fq.gz \
  in2=clean_R2.fq.gz \
  out=contigs_tadpole.fna \
  mode=contig
```

- Produces a single FASTA with contigs sorted by length.
- Use it to compare contig statistics against SPAdes; large discrepancies can highlight assembly artefacts.

## Post-Assembly Checks
- Run `samtools flagstat mapped.bam` (from the QC step) to confirm mapping rates remain high when aligning reads back to the assembly.
- Inspect `spades_out/contigs.fasta` with `seqkit stats` (install via pixi if needed) to get N50, GC, and length summaries.
- Ensure there are no adapters or human contamination by running `bbduk.sh` in contaminant mode if you ingest external datasets.

Reliable assemblies underpin everything else—treat the SPAdes log and post-assembly statistics as required reading for each dataset.
