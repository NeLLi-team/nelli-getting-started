# Protein Clustering Workflows

## Why Cluster?
Protein clustering reduces redundancy, accelerates downstream annotation, and helps us study gene family diversity. The tools below let you strike different balances between speed and sensitivity.

## MMseqs2 Linclust (Default)

```bash
mmseqs createdb proteins.faa db
mmseqs linclust db db_clu tmp --min-seq-id 0.9 -c 0.8 --cov-mode 1
mmseqs createtsv db db db_clu clusters.tsv
```

- `--min-seq-id 0.9` groups proteins sharing ≥90 % identity.
- `-c 0.8 --cov-mode 1` enforce coverage on the shorter sequence.
- Outputs both the representative sequence per cluster and a TSV listing cluster membership. Feed this into notebooks for functional summaries.

## CD-HIT

```bash
cd-hit -i proteins.faa -o proteins90.faa -c 0.9 -n 5 -T 8 -M 32000
```

- Efficient for large protein sets when you only need the representative sequences.
- Adjust `-n` (word size) when targeting different identity thresholds (`-c 0.95` → `-n 5`, `-c 0.7` → `-n 4`).
- Produces `proteins90.faa` plus a `.clstr` file enumerating cluster membership.

## DIAMOND Linclust

```bash
diamond makedb --in proteins.faa -d proteins
diamond cluster --db proteins --out clusters_diamond.tsv --linclust --min-id 0.9
```

- Useful when MMseqs2 is unavailable; leverages DIAMOND’s fast aligner.
- The `clusters_diamond.tsv` output mirrors the MMseqs2 TSV, making it easy to swap between tools.

## Interpreting Results
- Count clusters to gauge diversity; a high number of singletons may indicate assembly fragmentation.
- Track representative sequences to feed into annotation tools (eg. eggNOG-mapper, InterProScan).
- Version-control `clusters.tsv` outputs for reproducibility—small parameter tweaks can radically change cluster counts.

Pick the tool that matches your dataset size and time budget. For onboarding exercises, MMseqs2’s `linclust` strikes the right balance between speed and transparency.
