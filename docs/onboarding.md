# Onboarding Guide

Welcome to the Nelli bioinformatics team! This guide gives you the context, commands, and checkpoints you need to be productive with our metagenomics workflow. Keep a terminal open alongside these notes—every section references runnable scripts so you can immediately practice the concepts.

## 1. Big Picture: From Reads to Biological Insight

We focus on reconstructing genomes from complex metagenomes and placing them in a taxonomic context. The canonical pipeline looks like this:

```
raw reads → quality control → assembly → binning → annotation & clustering → phylogeny/taxonomy → reporting
```

Each stage has a dedicated script, data checkpoint, and documentation page in this repository. Running through the full sequence on the included toy dataset takes under 15 minutes and mirrors what you will do on production datasets that are several orders of magnitude larger.

## 2. Environment and Tooling

- **pixi** is our single source of truth for tool versions. `pixi install` resolves everything listed in `pixi.toml`, including heavy CLI tools from `conda-forge` and `bioconda`.
- BBTools utilities (bbduk, bbmap, tadpole, quickbin) run through `scripts/run_bbtools.sh`. If they are not available on your PATH, the script automatically uses the `bryce911/bbtools:latest` Docker image. Install Docker before you begin.
- Jupyter notebooks live in `notebooks/` and assume the same environment. Launch them with `pixi run nb` or, for Python-only exploration, `uv run jupyter lab`.

### Smoke Test

`pixi run smoke-test` orchestrates the critical steps to ensure your workstation is ready:

1. Validates that pixi can solve the environment and that Docker is reachable.
2. Downloads the CAMI toy dataset and regenerates the mock reads if they are absent.
3. Executes a trimmed-down version of the end-to-end workflow with verbose logging.
4. Prints follow-up instructions if any component fails.

Run it any time you change machines or upgrade dependencies.

## 3. Data Foundations

- `data/examples/` holds the canonical toy genome (`example.fna`), protein sequences (`example.faa`), and metadata we use across all tutorials.
- `data/downloads.sh` fetches external resources: the CAMI II toy reads (<50 MB) and a small list of MBARC-26 accessions for SRA practice. The smoke test calls this script automatically, but you can run it standalone.
- Generated data (mock reads, assemblies, bins, alignments, trees) live at the repository root. `make clean` removes lightweight intermediates; `make clean-hard` wipes all generated content.

## 4. Workflow Modules

The table below links each pipeline stage to the relevant documentation, script, and expected outcome. Work through them in order; every step feeds into the next.

| Stage | Why it matters | How to run | Reference |
|-------|----------------|-----------|-----------|
| Quality control & mapping | Remove adapters, correct biases, and quantify per-contig depth. | `bash scripts/qc_map.sh data/mock/mock_R1.fq.gz data/mock/mock_R2.fq.gz data/examples/example.fna` | `docs/01_reads_and_bbtools.md` |
| Assembly | Convert cleaned reads into contigs for downstream analysis. | `bash scripts/assemble_spades.sh clean_R1.fq.gz clean_R2.fq.gz` | `docs/04_assembly.md` |
| Depth summarisation | Build coverage profiles for binning tools. | `jgi_summarize_bam_contig_depths --outputDepth depth.txt mapped.bam` | `docs/01_reads_and_bbtools.md` |
| Binning | Recover draft genomes using coverage and composition signals. | `bash scripts/bin_metabat2.sh spades_out/contigs.fasta depth.txt` | `docs/03_binning.md` |
| Protein clustering | Collapse redundancy and build families for annotation. | `bash scripts/cluster_mmseqs2.sh data/examples/example.faa` | `docs/05_clustering.md` |
| Alignment & trimming | Prepare marker genes for phylogenetics. | `bash scripts/align_mafft.sh example.norm.faa` then `trimal -in aln.faa -out aln.trim.faa -automated1` | `docs/06_phylogeny_taxonomy_workflow.md` |
| Phylogenetic inference | Place genomes into a taxonomic framework. | `bash scripts/tree_iqtree.sh aln.trim.faa` | `docs/06_phylogeny_taxonomy_workflow.md` |

## 5. Hands-On Progression

1. **Generate mock data** — `bash scripts/make_mock_reads.sh` creates paired-end reads from `example.fna`. Inspect the output with `zcat data/mock/mock_R1.fq.gz | head`.
2. **QC & mapping lab** — Run `bash scripts/qc_map.sh ...` and open `depth.txt` to see coverage per contig. Note how the accompanying `docs/01_reads_and_bbtools.md` explains parameter choices.
3. **Assembly lab** — Execute `bash scripts/assemble_spades.sh clean_R1.fq.gz clean_R2.fq.gz` and browse `spades_out/contigs.fasta`. Compare contig lengths and coverage statistics.
4. **Binning lab** — `bash scripts/bin_metabat2.sh spades_out/contigs.fasta depth.txt` produces bins in `bins_metabat2/`. Inspect the accompanying log to understand how coverage and tetranucleotide frequency drive binning decisions.
5. **Protein clustering lab** — Normalize headers (`python scripts/normalize_headers.py ...`) and cluster proteins with `bash scripts/cluster_mmseqs2.sh example.norm.faa`. Review `clusters.tsv` to see how similarity thresholds change cluster counts.
6. **Phylogeny lab** — Align (`bash scripts/align_mafft.sh example.norm.faa`), trim (`trimal ...`), and infer trees (`bash scripts/tree_iqtree.sh aln.trim.faa`). Examine the resulting `.treefile` in your preferred viewer.

Document what you observe in each step—coverage ranges, assembly statistics, bin completeness/contamination scores—in your onboarding notebook. Those observations form the basis of your first read-out to your mentor.

## 6. Troubleshooting and Support

- Re-run `pixi install` if you modify the dependency list.
- If a script fails because a tool is missing, run the corresponding Makefile target (for example `make env-check`) to pinpoint the gap.
- Docker issues? Check that the daemon is running and that you can pull `bryce911/bbtools:latest` manually (`docker pull bryce911/bbtools:latest`).
- For reproducibility, avoid installing additional packages directly into the pixi environment. Instead, propose additions via `pixi.toml`.

## 7. Beyond the Basics

- Explore the notebooks in `notebooks/` to see interactive analyses built on the same datasets.
- Use `docs/02_taxonomy_basics.md` as a primer on GTDB, SeqCode, and the taxonomic standards we follow.
- When you are ready for larger data, swap the toy dataset for a subset of MBARC-26 using the accession list in `data/downloads/MBARC26_accessions.txt` and mirror the workflow on real SRA reads.

Welcome aboard—this guide should get you shipping analyses quickly. Keep iterating on it: every improvement you contribute will make the next teammate’s first week smoother.
