# nelli-getting-started

Hands-on tutorial repo for new team members. Shows basics of reads QC, assembly, binning, clustering, and phylogeny with short, runnable examples.

## Pick your environment
- **uv** (Python only; fast): `uv sync -p 3.11 && uv run jupyter lab`
- **pixi** (Python + CLI bio tools): `pixi install && pixi shell`

Environment manifests: root `pixi.toml` (mirrors `envs/pixi.toml`) and `envs/pyproject.toml`.

## Run the 10-minute demo
```bash
bash scripts/setup_test_data.sh
pixi install
pixi run demo
```

## Header normalization

We standardize FASTA headers to `>GENOME|ID`. Normalize any FNA/FAA:

```bash
python scripts/normalize_headers.py -i input.fna -o normalized.fna --genome-id SAMPLE1
python scripts/normalize_headers.py -i input.faa -o normalized.faa --genome-id SAMPLE1
```

## Learn more

* `docs/00_fasta_formats.md` — FNA/FAA & header rules
* `docs/01_reads_and_bbtools.md` — QC, mapping, depths
* `docs/02_taxonomy_basics.md` — GTDB, SeqCode, GTDB-Tk, QuickClade, TaxonKit
* `docs/03_binning.md` — MetaBAT2, SemiBin2, QuickBin
* `docs/04_assembly.md` — SPAdes, Tadpole
* `docs/05_clustering.md` — MMseqs2, CD-HIT, DIAMOND cluster
* `docs/06_phylogeny_taxonomy_workflow.md` — MAFFT→trimAl→IQ-TREE / FastTree

## Notes

* `scripts/setup_test_data.sh` downloads reference datasets and generates mock reads.
* Use `pixi` if you want the full CLI stack from Bioconda/conda-forge.
* Use `uv` for Python-only tutorials and notebooks.
* BBTools utilities run through `scripts/run_bbtools.sh`, which defaults to Docker image `bryce911/bbtools:latest` (override with `BBTOOLS_IMAGE`).
