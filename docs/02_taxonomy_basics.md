# Taxonomy and Nomenclature Fundamentals

## Why It Matters
After binning genomes, we need to decide what they are, whether they are novel, and how to report them. Taxonomic assignments influence downstream analyses, QC thresholds, and how we communicate results to project partners.

## Core Resources

### Genome Taxonomy Database (GTDB)
- Phylogenetically consistent taxonomy for bacteria and archaea built from concatenated marker genes.
- Run **GTDB-Tk** on high-quality bins to obtain lineage calls, relative evolutionary divergence (RED) scores, and flags for potential contamination.

```bash
gtdbtk classify_wf \
  --genome_dir bins/ \
  --out_dir gtdbtk_out \
  --extension fa \
  --cpus 8
```

Deliverables worth retaining:
- `gtdbtk.bac_summary.tsv` or `gtdbtk.ar122_summary.tsv` — primary lineage table.
- Placement trees under `gtdbtk_out/classify/trees/` for visual inspection.
- FastANI and alignment statistics used internally by GTDB-Tk to justify the call.

### SeqCode
- Community framework for naming uncultivated organisms based solely on genomic evidence.
- Use it to check whether a bin meets the `>=90%` completeness and `<=5%` contamination requirements for candidatus naming, and to track reserved names.

### QuickClade (BBTools)
- K-mer based classifier useful for rapid triage or when GTDB reference data is unavailable.
- Handy for highlighting mixed bins: contigs assigned to different high-level taxa likely indicate contamination.

```bash
bash scripts/run_bbtools.sh quickclade.sh in=bins_metabat2/bin.1.fa out=quickclade.tsv
```

### TaxonKit
- Lightweight CLI for working with the NCBI taxonomy. We use it to convert TaxIDs obtained from other tools into canonical lineage strings or to prune lineages to a specific rank.

```bash
echo 562 | taxonkit lineage | taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s}"
```

## Suggested Workflow
1. Run GTDB-Tk on each high-quality bin created during onboarding (`bins_metabat2` is a good starting point).
2. Cross-check suspicious bins with QuickClade and assembly statistics to rule out contamination.
3. Summarise findings in a spreadsheet: include completeness/contamination scores (from CheckM or MetaQUAST), GTDB assignment, and SeqCode eligibility.
4. Use TaxonKit to enrich the final report with human-readable lineage strings.

Consistent taxonomy keeps our downstream comparative analyses trustworthy—invest the time to understand the evidence behind each assignment.
