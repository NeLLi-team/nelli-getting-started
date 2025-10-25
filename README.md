# nelli-getting-started

Practical onboarding for the Nelli bioinformatics team. This repository gives new joiners a curated walk-through of the core metagenomics workflow—read QC, assembly, binning, clustering, and phylogenetics—using tiny, reproducible datasets and a single, reproducible environment definition.

The goal: make it possible to land on a fresh laptop and, within an afternoon, understand **what** we do, **why** each step matters, and **how** to reproduce it.

## Quick Start Checklist (≈10 min)
1. Install [pixi](https://pixi.sh/latest/) and Docker (BBTools helpers use a container fallback).
2. Fetch the sandbox datasets and mock reads: `bash scripts/setup_test_data.sh`
3. Create the toolchain: `pixi install`
4. Validate everything end-to-end: `pixi run smoke-test`
5. Explore the richer demo: `pixi run demo`

Every command is verbose and will stop with a clear error message if a dependency is missing.

## Environment Options
- **pixi (recommended)** — provides Python plus the CLI tools we rely on (SPAdes, MetaBAT2, MAFFT, IQ-TREE, etc.). The manifest lives in `pixi.toml` and mirrors `envs/pixi.toml`.
- **uv** — fastest route to the Python packages and notebooks in `notebooks/`. Use it when you do not need heavy CLI tools: `uv sync -p 3.11 && uv run jupyter lab`.

## Learning Roadmap
Follow `docs/onboarding.md` for a guided tour. It covers:
- Orientation and workflow diagram
- Data standards (FASTA headers, metadata expectations)
- Hands-on labs for QC, assembly, binning, clustering, tree building, and taxonomy
- How to interpret outputs and decide the next action at each step

Each topic links to deeper reference notes (for example `docs/04_assembly.md` for assembly details) and the companion scripts in `scripts/` that implement the reproducible commands.

## Repository Layout
- `docs/` — onboarding guide plus topic deep dives.
- `scripts/` — small, composable shell wrappers for every workflow step.
- `python/` — Python helpers, e.g. FASTA header normalization.
- `notebooks/` — exploration notebooks that mirror the scripted pipeline.
- `data/` — tiny example genomes, FASTQs, and download scripts.
- `envs/` — alternative environment manifests (`pixi.toml`, `pyproject.toml`).

## Data Used in Training
- `data/examples/` contains the canonical tiny genome and protein inputs used across all tutorials.
- `scripts/setup_test_data.sh` calls `data/downloads.sh` to fetch a <50 MB CAMI toy dataset and prepare mock reads so we can exercise the full pipeline without large downloads.
- Outputs from tutorials live at the repo root (assemblies, bins, alignments). `make clean` and `make clean-hard` remove them.

## Header Normalization Utility
Consistent FASTA headers keep downstream tooling happy. Use `scripts/normalize_headers.py` to enforce the `>GENOME|ID` pattern:

```bash
python scripts/normalize_headers.py -i input.fna -o normalized.fna --genome-id SAMPLE1
python scripts/normalize_headers.py -i input.faa -o normalized.faa --genome-id SAMPLE1
```

## Where to Go Next
1. Complete `pixi run smoke-test` to prove your setup.
2. Walk through the annotated sections in `docs/onboarding.md` with the scripts and notebooks open.
3. Use the Makefile targets (`make demo`, `make assemble-spades`, …) to practice running individual stages.
4. Pair with a teammate on a real dataset once you are comfortable with the mock runs.

If you spot a gap or need a new tutorial, open an issue or drop your notes in `docs/`—onboarding is a living document.
