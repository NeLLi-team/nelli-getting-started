# FASTA, FNA, and FAA Conventions

## Why This Matters
Consistent FASTA formatting prevents subtle bugs in downstream tooling (duplicate identifiers, non-ASCII characters, unexpected whitespace). We adhere to a strict naming scheme so every contig or protein can be traced back to its genome of origin.

## File Types
- **FASTA** — generic container for biological sequences. A header line starting with `>` is followed by one or more sequence lines.
- **FNA** — FASTA with nucleotide sequences; most assemblers and binning tools expect `.fna` files.
- **FAA** — FASTA with amino acid sequences; used for clustering, annotation, and phylogenetics.

## Header Policy
- Format: `>{GENOME_ID}|{FEATURE_ID}` (uppercase genome IDs, no spaces, alphanumerics plus `_` or `-`).
- Keep feature identifiers monotonic and unique (`contig_0001`, `ORF_0001`).
- Store auxiliary metadata (length, product description) in tabular sidecar files, not in the FASTA header.

## Normalising Headers
Always run incoming FASTA files through the helper script before committing them to the repo or using them in tutorials:

```bash
python scripts/normalize_headers.py -i input.fna -o normalized.fna --genome-id SAMPLE1
python scripts/normalize_headers.py -i input.faa -o normalized.faa --genome-id SAMPLE1
```

The script strips whitespace, converts Unicode to plain ASCII, collapses duplicate IDs, and validates that all headers match the expected pattern. It exits with a non-zero status if it encounters a violation.

## Quick Validations

```bash
# Inspect the first few headers
grep -n "^>" normalized.fna | head

# Ensure there are no lowercase nucleotides or ambiguous amino acid codes
awk 'NR%2==0 { if($0 ~ /[^ACGTN]/) exit 1 }' normalized.fna
awk 'NR%2==0 { if($0 ~ /[^ACDEFGHIKLMNPQRSTVWYBXZ\*]/) { print "Non-standard residue line:"; print $0; exit 1 } }' normalized.faa
```

Treat FASTA hygiene as a gating step—clean inputs save hours downstream.
