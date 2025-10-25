# Phylogeny and Taxonomy Workflow

## Overview
Placing genomes into a phylogenetic context helps validate taxonomy, detect contamination, and communicate evolutionary relationships. Our workflow builds multiple sequence alignments of marker proteins, trims noisy regions, and infers trees with robust support values.

## Pipeline Steps

### 1. Multiple Sequence Alignment (MAFFT)

```bash
mafft --auto proteins.faa > aln.faa
```

- `--auto` chooses an appropriate strategy based on dataset size; for very small sets you can force `--localpair --maxiterate 1000` for higher accuracy.
- Inspect the alignment with `aliview` or another viewer to verify there are no obvious misalignments.

### 2. Trim Low-Quality Columns (trimAl)

```bash
trimal -in aln.faa -out aln.trim.faa -automated1
```

- Removes poorly supported columns to reduce noise in tree inference.
- Use `-gt 0.5` as an alternative when you must keep more sites (e.g. for small marker sets).

### 3. Maximum-Likelihood Tree (IQ-TREE)

```bash
iqtree2 \
  -s aln.trim.faa \
  -m MFP \
  -B 1000 \
  -T AUTO
```

- `-m MFP` performs ModelFinder to choose the best substitution model.
- `-B 1000` runs ultrafast bootstrap replicates; adjust for higher confidence if runtime allows.
- Outputs: `.treefile`, `.iqtree` (run log + model details), `.log` (diagnostics). Always skim the `.iqtree` file for convergence warnings.

### 4. Fast Approximation (FastTree)

```bash
FastTree -wag -gamma aln.trim.faa > tree.nwk
```

- Use when you need a quick look or are working on underpowered hardware.

## Quality Checks
- Ensure branch support values (UFBoot) exceed 95% for key clades. Low support suggests you should revisit the alignment or increase bootstrap replicates.
- Confirm the outgroup and rooting strategy with your mentor before presenting trees; incorrect rooting can mislead interpretations.
- Use `ete3` or `iTOL` to visualise `.treefile` outputs; attach taxonomic metadata to highlight novel lineages.

Tree building is iterative—treat the output as evidence to scrutinise, not an unquestionable truth.
