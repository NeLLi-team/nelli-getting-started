* **FASTA**: header line starts with `>`, rest are sequence lines.
* **FNA**: nucleotides (contigs/assemblies).
* **FAA**: proteins.
* **Repo header convention**: `>{genome_id}|{contig_or_protein_id}`
* **Normalize** any source FASTA (NCBI/RefSeq/ENA) via:

  ```bash
  python scripts/normalize_headers.py -i input.fna -o normalized.fna --genome-id SAMPLE1
  python scripts/normalize_headers.py -i input.faa -o normalized.faa --genome-id SAMPLE1
  ```
* Quick sanity:

  ```bash
  grep -n "^>" normalized.fna | head
  ```

