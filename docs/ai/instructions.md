Got it—here’s a tight, agent-ready plan to scaffold **`nelli-getting-started`** as a hands-on tutorial repo for new team members. I’m giving you (1) repo layout, (2) step-by-step setup, (3) `uv` vs `pixi` environment files, (4) short docs outlines with runnable commands, and (5) links + latest versions (date) for every tool.

---

# 1) Repository layout

```
nelli-getting-started/
├─ README.md
├─ LICENSE
├─ envs/
│  ├─ pyproject.toml           # UV (Python-only deps)
│  └─ pixi.toml                # Pixi (Conda + Python + CLI tools)
├─ docs/
│  ├─ 00_fasta_formats.md
│  ├─ 01_reads_and_bbtools.md
│  ├─ 02_taxonomy_basics.md
│  ├─ 03_binning.md
│  ├─ 04_assembly.md
│  ├─ 05_clustering.md
│  └─ 06_phylogeny_taxonomy_workflow.md
├─ data/
│  ├─ examples/
│  │  ├─ example.fna           # nucleotides (FASTA)
│  │  ├─ example.faa           # proteins (FASTA)
│  │  └─ small_mock_assembly.fna
│  └─ downloads.sh             # fetch small mock reads (CAMI/MBARC)
├─ scripts/
│  ├─ qc_map.sh                # bbduk/bbmap demo
│  ├─ assemble_spades.sh
│  ├─ assemble_tadpole.sh
│  ├─ bin_metabat2.sh
│  ├─ bin_semibin2.sh
│  ├─ cluster_mmseqs2.sh
│  ├─ cluster_cdhit.sh
│  ├─ cluster_diamond.sh
│  ├─ align_mafft.sh
│  ├─ tree_iqtree.sh
│  ├─ tree_fasttree.sh
│  └─ taxonomy_tips.md
├─ notebooks/
│  ├─ 01_qc_and_stats.ipynb
│  └─ 02_downstream_ml.ipynb
└─ python/
   ├─ wrappers/
   │  ├─ diamond.py
   │  ├─ mafft.py
   │  ├─ trimal.py
   │  ├─ iqtree.py
   │  └─ mmseqs.py
   └─ examples/
      └─ mini_ml_pipeline.py
```

---

# 2) Onboarding steps (for agents to execute)

1. **Clone & choose environment manager**

   * For Python-only quickstarts use **uv** (fast, isolated). For full bio CLI stack, use **pixi** (Conda under the hood).
   * `git clone https://github.com/<org>/nelli-getting-started && cd nelli-getting-started`

2. **Option A — UV (Python only)**

   * Install uv (Linux/macOS): `curl -LsSf https://astral.sh/uv/install.sh | sh` (see official docs) ([docs.astral.sh][1])
   * Create env & install: `uv sync --frozen -p 3.11 -q -v`
   * Run notebooks: `uv run jupyter lab`

3. **Option B — Pixi (Python + bio tools from conda-forge/bioconda)**

   * Install pixi: follow site or GitHub releases. Then: `pixi install` → `pixi shell` ([Pixi][2])

4. **Get tiny example data**

   * `bash data/downloads.sh` (fetches **CAMI II toy** / MBARC links; small) ([Zenodo][3])

5. **Run a minimal end-to-end**

   * QC→assembly→binning→taxonomy pipeline with the provided scripts (each script has a `-h`).

---

# 3) Dependency management: **uv vs pixi** (with example files)

**Why two?**

* **uv** excels for Python libs (pandas/polars/seaborn/scikit-learn) and reproducible dev; it does **not** manage conda/bioconda CLI bio packages. ([GitHub][4])
* **pixi** is a modern front-end to the conda ecosystem, perfect to install **Diamond, MAFFT, IQ-TREE, trimAl, FastTree, BBTools, MMseqs2, MetaBAT2, SemiBin2, SPAdes, TaxonKit, CD-HIT** in one lockable environment. ([GitHub][5])

## `envs/pyproject.toml` (uv)

```toml
[project]
name = "nelli-getting-started"
version = "0.1.0"
description = "Tutorial repo for bioinformatics basics"
requires-python = ">=3.10"

dependencies = [
  "pandas>=2.3.0",
  "polars>=1.33.0",
  "seaborn>=0.13.2",
  "scikit-learn>=1.7.0",
  "jupyterlab",
]

[tool.uv]
# lockfile is uv.lock
```

(latest refs: **pandas 2.3.x (2025-09-29)**, **polars 1.34.0 (2025-10-02)**, **seaborn 0.13.2 (2024-01-25)**, **scikit-learn 1.7.2 (2025-09)**) ([Pandas][6])

## `envs/pixi.toml` (pixi + bioconda)

```toml
[project]
name = "nelli-getting-started"
channels = ["conda-forge", "bioconda"]
platforms = ["linux-64", "osx-64", "osx-arm64"]

[tasks]
notebook = "jupyter lab"

[dependencies]
python = "3.11.*"
pandas = ">=2.3.0"
polars = ">=1.33.0"
seaborn = ">=0.13.2"
scikit-learn = ">=1.7.0"
jupyterlab = "*"

# Bio CLI packages
diamond = "*"
mafft = "*"
trimal = "*"
iqtree = "*"
fasttree = "*"
bbmap = "*"
mmseqs2 = "*"
metabat2 = "*"
semibin = "*"         # may be packaged as semibin / semibin2 depending on channel
spades = "*"
taxonkit = "*"
cd-hit = "*"
```

> Note: **BBMap** suite is Java-based (no external deps), and includes utilities like **bbduk.sh**, **bbmap.sh**, **tadpole.sh**, **quickbin.sh**, **quickclade.sh**. ([bbmap.org][7])

---

# 4) Docs (short, runnable)

## `docs/00_fasta_formats.md` — FASTA basics

* **FASTA** = header line starts with `>` then sequence lines.
* **FNA** = nucleotide FASTA (e.g., contigs/assemblies).
* **FAA** = protein FASTA (amino acids).
* **Header convention for this repo:**
  `>{genome_id}|{contig_id_or_protein_id}`
  Examples in `data/examples/`.
* Quick checks:

  * Count records: `grep -c '^>' file.fna`
  * Translate headers: Python or `awk` one-liners.

## `docs/01_reads_and_bbtools.md` — Reads + BBTools/BBMap

* **BBMap/BBTools** references & guide (alignment, QC, k-mer tools). ([Archive][8])
* **Docker run** (no install on host):

  ```bash
  docker run --rm -v $PWD:/work -w /work staphb/bbtools:latest bbmap.sh --version
  ```

  (or any maintained bbtools image) ([RCAC][9])
* Typical QC:

  ```bash
  bbduk.sh in=reads_R1.fq.gz in2=reads_R2.fq.gz out1=clean_R1.fq.gz out2=clean_R2.fq.gz \
           ref=adapters ktrim=r k=23 mink=11 hdist=1 tpe tbo
  ```
* Map for coverage:

  ```bash
  bbmap.sh ref=assembly.fna in=clean_R1.fq.gz in2=clean_R2.fq.gz out=mapped.sam
  ```
* **Tadpole** (k-mer assembler & corrector) quick use:
  `tadpole.sh in=clean_R1.fq.gz in2=clean_R2.fq.gz out=contigs.fna mode=contig` ([Archive][10])
* **QuickClade** (rapid tax assignment) & **QuickBin** are included in BBTools; resources for QuickClade lives on SourceForge `Resources/` (spectra, taxtree). ([bbmap.org][7])

## `docs/02_taxonomy_basics.md` — GTDB, SeqCode, GTDB-Tk, QuickClade, TaxonKit

* **GTDB** (current release & scope). **Release 10-RS226 (2025-04-16)**. ([gtdb.ecogenomic.org][11])
* **SeqCode** (genome-sequence-based nomenclature; summary paper). ([Nature][12])
* **GTDB-Tk** (toolkit; latest notable change 2024-04: Skani-only clustering). ([GitHub][13])

  ```bash
  gtdbtk classify_wf --genome_dir bins/ --out_dir gtdbtk_out --extension fa --cpus 8
  ```
* **QuickClade** (BBTools) for k-mer tax calls (see 01 doc). ([bbmap.org][7])
* **TaxonKit** for NCBI TaxID lookups & lineage:

  ```bash
  echo -e "562\n1280" | taxonkit lineage | taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s}"
  ```

  (v0.19.0 in 2025-03) ([GitHub][14])

## `docs/03_binning.md` — MetaBAT2, SemiBin2, QuickBin

* **MetaBAT2** (adaptive binning; paper + packaging). ([PMC][15])

  ```bash
  jgi_summarize_bam_contig_depths --outputDepth depth.txt mapped.bam
  metabat2 -i assembly.fna -a depth.txt -o bins/bin
  ```
* **SemiBin2** (self-supervised, faster/better than v1; v2.2.0 released 2025-03-20). ([GitHub][16])

  ```bash
  SemiBin2 single_easy_bin -i assembly.fna -r clean_R1.fq.gz clean_R2.fq.gz -o semibin_out
  ```
* **QuickBin** (BBTools helper): `quickbin.sh in=assembly.fna out=bins/` (see BBTools list). ([Debian Packages][17])

## `docs/04_assembly.md` — SPAdes & Tadpole

* **SPAdes** (4.x line; 2024-06 note). ([GitHub][18])

  ```bash
  spades.py -1 clean_R1.fq.gz -2 clean_R2.fq.gz -o spades_out --careful -t 8 -m 32
  ```
* **Tadpole** (very fast micro-assembler; see guide). ([Archive][10])

  ```bash
  tadpole.sh in=clean_R1.fq.gz in2=clean_R2.fq.gz out=contigs.fna mode=contig
  ```

## `docs/05_clustering.md` — MMseqs2 Linclust, CD-HIT, DIAMOND cluster, PhyloDM

* **MMseqs2** (Release 15 series; linclust & greedy clustering). ([GitHub][19])

  ```bash
  mmseqs createdb proteins.faa db && \
  mmseqs linclust db db_clu tmp --min-seq-id 0.9 -c 0.8 --cov-mode 1 && \
  mmseqs createtsv db db db_clu clusters.tsv
  ```
* **CD-HIT** (classic fast clustering). ([GitHub][20])

  ```bash
  cd-hit -i proteins.faa -o proteins90.faa -c 0.9 -n 5 -T 8 -M 32000
  ```
* **DIAMOND** new clustering modes (v2.1.14, 2025-09-12). ([GitHub][21])

  ```bash
  diamond makedb --in proteins.faa -d prot && \
  diamond cluster --db prot --out clusters_diamond.tsv --linclust --min-id 0.9
  ```
* **PhyloDM** (tree→distance matrix; Python/Rust lib). ([GitHub][22])

## `docs/06_phylogeny_taxonomy_workflow.md` — MAFFT → trimAl → IQ-TREE / FastTree2

* **MAFFT** latest **7.526 (2024-04)**; `mafft-linsi` for difficult sets. ([MAFFT][23])

  ```bash
  mafft --auto proteins.faa > aln.faa
  # or high-accuracy:
  mafft-linsi proteins.faa > aln_linsi.faa
  ```
* **trimAl** **v1.5.0 (2024-07-02)** for alignment trimming. ([GitHub][24])

  ```bash
  trimal -in aln.faa -out aln.trim.faa -automated1
  ```
* **IQ-TREE** **v3.0.1 (2025-05-05)**; IQ-TREE 2 LTS releases also listed. ([iqtree.github.io][25])

  ```bash
  iqtree2 -s aln.trim.faa -m MFP -B 1000 -T AUTO
  ```
* **FastTree2** (very fast approx-ML; repo & paper). ([GitHub][26])

  ```bash
  FastTree -wag -gamma aln.trim.faa > tree.nwk
  ```

---

# 5) Example data + downloads

**`data/examples/`** (checked into repo):

* `example.fna` — tiny contig set with headers like `GENO1|contig0001`.
* `example.faa` — proteins with headers like `GENO1|prot_0001`.

**`data/downloads.sh`** (small reads; CAMI-II “toy” and MBARC-26 references):
Include a couple of `curl`/`wget` lines to pull one small paired-end set (or gold-standard assemblies) from Zenodo CAMI-II toy, plus MBARC-26 accession pointer for SRA. ([Zenodo][3])

---

# 6) Minimal scripts (examples)

**`scripts/cluster_mmseqs2.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail
IN=${1:-data/examples/example.faa}
mmseqs createdb "$IN" db
mmseqs linclust db db_clu tmp --min-seq-id 0.9 -c 0.8 --cov-mode 1
mmseqs createtsv db db db_clu clusters.tsv
echo "Wrote clusters.tsv"
```

**`python/examples/mini_ml_pipeline.py`** (sketch)

```python
import pandas as pd, polars as pl
from sklearn.ensemble import RandomForestClassifier
# load feature table from clusters/alignments, fit toy model...
```

---

# 7) README.md essentials

* One-liner mission + repo map.
* “Pick your env: uv or pixi.”
* “Run the 10-minute demo”: `bash scripts/assemble_spades.sh` → `bash scripts/bin_metabat2.sh` → `bash scripts/tree_iqtree.sh`.
* Links + latest versions table (tool → version → date → homepage/GitHub):

| Tool                  | Latest / Date                                   | Link                           |
| --------------------- | ----------------------------------------------- | ------------------------------ |
| uv                    | **Latest release 2025-10-07**                   | ([GitHub][4])                  |
| pixi                  | Active releases (2025)                          | ([GitHub][27])                 |
| DIAMOND               | **v2.1.14 (2025-09-12)**                        | ([GitHub][21])                 |
| BLAST+                | (NCBI BLAST News / docs)                        | ([blast.ncbi.nlm.nih.gov][28]) |
| MAFFT                 | **7.526 (2024-04)**                             | ([MAFFT][23])                  |
| trimAl                | **v1.5.0 (2024-07-02)**                         | ([GitHub][24])                 |
| IQ-TREE               | **v3.0.1 (2025-05-05)**; IQ-TREE2 releases page | ([iqtree.github.io][25])       |
| FastTree2             | repo & paper                                    | ([GitHub][26])                 |
| pandas                | **2.3.x (2025-09-29)**                          | ([Pandas][6])                  |
| polars                | **1.34.0 (2025-10-02)**                         | ([PyPI][29])                   |
| seaborn               | **0.13.2 (2024-01-25)**                         | ([PyPI][30])                   |
| scikit-learn          | **1.7.2 (2025-09)**                             | ([Scikit-learn][31])           |
| BBTools/BBMap         | official site & user guide                      | ([bbmap.org][7])               |
| MMseqs2               | Release 15 series (2024–25)                     | ([GitHub][19])                 |
| CD-HIT                | repo / bioconda                                 | ([GitHub][20])                 |
| MetaBAT2              | paper & bioconda                                | ([PMC][15])                    |
| SemiBin2              | **v2.2.0 (2025-03-20)**                         | ([GitHub][16])                 |
| SPAdes                | 4.x (2024-06)                                   | ([GitHub][18])                 |
| TaxonKit              | **v0.19.0 (2025-03)**                           | ([GitHub][14])                 |
| GTDB                  | **R10-RS226 (2025-04-16)**                      | ([gtdb.ecogenomic.org][11])    |
| GTDB-Tk               | 2024-04 changes                                 | ([GitHub][32])                 |
| QuickClade / QuickBin | in BBTools                                      | ([bbmap.org][7])               |

---

# 8) Agent notes (design choices)

* Prefer **pixi** for the bio CLI stack to avoid bespoke Dockerfiles; use Docker only where convenient (e.g., bbtools). ([Pixi][2])
* Keep **uv** for Python tutorials, plotting, and ML demos; it’s blazing fast and simple. ([docs.astral.sh][1])
* Use **CAMI-II “toy”** or **MBARC-26** for tiny, reproducible datasets; both are widely used in benchmarking and easy to fetch. ([Zenodo][3])

---

If you want, I can drop in the actual `README.md`, both env files, all stub docs, and the shell scripts as paste-ready content next.

[1]: https://docs.astral.sh/uv/getting-started/installation/?utm_source=chatgpt.com "Installation | uv - Astral Docs"
[2]: https://pixi.sh/?utm_source=chatgpt.com "Pixi"
[3]: https://zenodo.org/records/15083711?utm_source=chatgpt.com "CAMI2 toy human microbiome short read gold standard ..."
[4]: https://github.com/astral-sh/uv/releases?utm_source=chatgpt.com "Releases · astral-sh/uv"
[5]: https://github.com/prefix-dev/pixi?utm_source=chatgpt.com "prefix-dev/pixi: Package management made easy"
[6]: https://pandas.pydata.org/docs/whatsnew/index.html?utm_source=chatgpt.com "Release notes — pandas 2.3.3 documentation - PyData |"
[7]: https://bbmap.org/?utm_source=chatgpt.com "BBMap - Official BBTools Suite by Brian Bushnell"
[8]: https://archive.jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbmap-guide/?utm_source=chatgpt.com "BBMap Guide - Archive - Department of Energy"
[9]: https://www.rcac.purdue.edu/software/bbtools?utm_source=chatgpt.com "Software: BBTools - RCAC"
[10]: https://archive.jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/tadpole-guide/?utm_source=chatgpt.com "Tadpole Guide - Archive - Department of Energy"
[11]: https://gtdb.ecogenomic.org/?utm_source=chatgpt.com "GTDB - Genome Taxonomy Database"
[12]: https://www.nature.com/articles/s41564-022-01214-9?utm_source=chatgpt.com "SeqCode: a nomenclatural code for prokaryotes described ..."
[13]: https://github.com/Ecogenomics/GTDBTk?utm_source=chatgpt.com "Ecogenomics/GTDBTk: GTDB-Tk"
[14]: https://github.com/shenwei356/taxonkit/releases?utm_source=chatgpt.com "Releases · shenwei356/taxonkit"
[15]: https://pmc.ncbi.nlm.nih.gov/articles/PMC6662567/?utm_source=chatgpt.com "MetaBAT 2: an adaptive binning algorithm for robust and ..."
[16]: https://github.com/BigDataBiology/SemiBin/releases?utm_source=chatgpt.com "Releases · BigDataBiology/SemiBin"
[17]: https://packages.debian.org/forky/all/bbmap/filelist?utm_source=chatgpt.com "File list of package bbmap in forky of architecture all"
[18]: https://github.com/ablab/spades/releases?utm_source=chatgpt.com "Releases · ablab/spades"
[19]: https://github.com/soedinglab/MMseqs2/releases?utm_source=chatgpt.com "Releases · soedinglab/MMseqs2"
[20]: https://github.com/weizhongli/cdhit?utm_source=chatgpt.com "GitHub - weizhongli/cdhit: Automatically exported from ..."
[21]: https://github.com/bbuchfink/diamond?utm_source=chatgpt.com "bbuchfink/diamond: Accelerated BLAST compatible local ..."
[22]: https://github.com/aaronmussig/PhyloDM?utm_source=chatgpt.com "aaronmussig/PhyloDM: Efficient calculation of phylogenetic ..."
[23]: https://mafft.cbrc.jp/alignment/software/?utm_source=chatgpt.com "a multiple sequence alignment program"
[24]: https://github.com/inab/trimal/releases?utm_source=chatgpt.com "Releases · inab/trimal"
[25]: https://iqtree.github.io/?utm_source=chatgpt.com "IQ-TREE: Efficient phylogenomic software by maximum ..."
[26]: https://github.com/morgannprice/fasttree?utm_source=chatgpt.com "FastTree 2: Approximately-Maximum-Likelihood Trees for ..."
[27]: https://github.com/prefix-dev/pixi/releases?utm_source=chatgpt.com "Releases · prefix-dev/pixi"
[28]: https://blast.ncbi.nlm.nih.gov/doc/blast-news/2025-BLAST-News.html?utm_source=chatgpt.com "2025 BLAST NEWS — BlastNews 0.1.1 documentation"
[29]: https://pypi.org/project/polars/?utm_source=chatgpt.com "polars"
[30]: https://pypi.org/project/seaborn/?utm_source=chatgpt.com "seaborn"
[31]: https://scikit-learn.org/?utm_source=chatgpt.com "scikit-learn: machine learning in Python — scikit-learn 1.7.2 ..."
[32]: https://github.com/Ecogenomics/GTDBTk/releases?utm_source=chatgpt.com "Releases · Ecogenomics/GTDBTk"

Awesome—here’s the **companion pack** to your first answer: paste-ready files and scripts so an agent can scaffold the repo in one go. I also added **header-normalization** utilities to make NCBI/RefSeq downloads consistent (`{genome_id}|{contig_or_protein_id}`).

---

# 0) Quick-start (agent steps)

```bash
# 1) create repo locally
repo=nelli-getting-started && mkdir -p $repo && cd $repo

# 2) lay down structure
mkdir -p envs docs data/examples data/mock community scripts python/{wrappers,examples} notebooks

# 3) copy-paste the files from below into the matching paths

# 4) choose env:
#    A) uv (python only)
#       curl -LsSf https://astral.sh/uv/install.sh | sh
#       uv sync -p 3.11 && uv run jupyter lab
#    B) pixi (bio CLI + python)
#       curl -fsSL https://pixi.sh/install.sh | bash
#       pixi install && pixi shell

# 5) run a tiny end-to-end demo (mock reads → assembly → binning → clustering → tree)
bash scripts/demo_all.sh
```

---

# 1) Environment files

## `envs/pyproject.toml` (uv – Python stack only)

```toml
[project]
name = "nelli-getting-started"
version = "0.1.0"
description = "Tutorial repo for bioinformatics basics"
readme = "README.md"
requires-python = ">=3.10"

dependencies = [
  "pandas>=2.3.0",
  "polars>=1.33.0",
  "seaborn>=0.13.2",
  "scikit-learn>=1.7.0",
  "jupyterlab>=4.0.0",
  "biopython>=1.83",
]

[tool.uv]
# lockfile: uv.lock (auto-generated)
```

## `envs/pixi.toml` (pixi – Python + CLI bio tools)

```toml
[project]
name = "nelli-getting-started"
channels = ["conda-forge", "bioconda"]
platforms = ["linux-64", "osx-64", "osx-arm64"]

[tasks]
nb = "jupyter lab"
demo = "bash scripts/demo_all.sh"

[dependencies]
python = "3.11.*"
pandas = ">=2.3.0"
polars = ">=1.33.0"
seaborn = ">=0.13.2"
scikit-learn = ">=1.7.0"
jupyterlab = "*"
biopython = ">=1.83"

# bio cli
bbmap = "*"
spades = "*"
metabat2 = "*"
semibin = "*"         # package name may be semibin / semibin2 depending on channel
mmseqs2 = "*"
cd-hit = "*"
diamond = "*"
mafft = "*"
trimal = "*"
iqtree = "*"
fasttree = "*"
taxonkit = "*"
```

---

# 2) Example data (tiny, self-contained)

## `data/examples/example.fna`

```fasta
>GENO1|contig0001
ATGGCGTATGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAG
>GENO1|contig0002
ATGCGATCGATCGATCGATCGGGCTAGCTAGCTAGCTAGCTAGCTA
```

## `data/examples/example.faa`

```fasta
>GENO1|prot_0001
MKTLLVLATVALATATDA
>GENO1|prot_0002
MNNRKLEAQLKKLAAADA
```

---

# 3) Header normalization (works for NCBI/RefSeq FASTA)

### What it does

* Makes headers uniform: `>{genome_id}|{contig_id}` for **FNA** or `>{genome_id}|{protein_id}` for **FAA**.
* Pulls `{contig_id}` or `{protein_id}` as the **first token** before the first space in an NCBI header (e.g., `>NZ_CP012345.1 something` → `contig_id=NZ_CP012345.1`).
* You pass `--genome-id` (e.g., your sample or assembly name). If not given, it uses the **stem of the input filename**.

## `scripts/normalize_headers.py`

```python
#!/usr/bin/env python3
import sys, argparse, os
from Bio import SeqIO

def main():
    ap = argparse.ArgumentParser(description="Normalize FASTA headers to {genome_id}|{id}")
    ap.add_argument("-i","--in", dest="inp", required=True, help="input .fna or .faa")
    ap.add_argument("-o","--out", dest="out", required=True, help="output fasta")
    ap.add_argument("--genome-id", dest="gid", default=None, help="genome/sample ID to prefix (default=filename stem)")
    args = ap.parse_args()

    gid = args.gid or os.path.splitext(os.path.basename(args.inp))[0]
    count = 0
    with open(args.out, "w") as out_f:
        for rec in SeqIO.parse(args.inp, "fasta"):
            # take the first token of original header as contig/protein id
            tok = rec.id  # SeqIO already splits at whitespace; rec.id is token0
            rec.id = f"{gid}|{tok}"
            rec.description = ""  # keep it clean
            SeqIO.write(rec, out_f, "fasta")
            count += 1
    sys.stderr.write(f"Wrote {count} records to {args.out}\n")

if __name__ == "__main__":
    main()
```

**Usage examples**

```bash
# NCBI RefSeq genomes: headers like ">NZ_CP012345.1 ..."
python scripts/normalize_headers.py -i raw/genome.fna -o normalized/genome.norm.fna --genome-id SAMPLE1

# NCBI protein: headers like ">WP_123456789.1 ..."
python scripts/normalize_headers.py -i raw/proteins.faa -o normalized/proteins.norm.faa --genome-id SAMPLE1
```

> Tip: If you already embed `{genome_id}` in filenames, you can skip `--genome-id`. The script uses `basename(input)` as default.

---

# 4) Tiny mock reads (no internet required)

We’ll **simulate reads** from `example.fna` with **BBTools** (avoids downloading SRA/Zenodo). You’ll get paired-end FASTQ in `data/mock/`.

## `scripts/make_mock_reads.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
IN="data/examples/example.fna"
OUTDIR="data/mock"
mkdir -p "$OUTDIR"

# create 50k paired reads @150bp from two contigs with 1% error and 0.5% indels
randomreads.sh ref="$IN" out1="$OUTDIR/mock_R1.fq.gz" out2="$OUTDIR/mock_R2.fq.gz" \
    len=150 paired snprate=0.01 insrate=0.002 delrate=0.003 coverage=50
echo "Mock reads written to $OUTDIR/"
```

---

# 5) Core demo scripts (small, fast)

## `scripts/qc_map.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
R1=${1:-data/mock/mock_R1.fq.gz}
R2=${2:-data/mock/mock_R2.fq.gz}
ASM=${3:-data/examples/example.fna}

# QC
bbduk.sh in="$R1" in2="$R2" out1=clean_R1.fq.gz out2=clean_R2.fq.gz \
    ref=adapters ktrim=r k=23 mink=11 hdist=1 tpe tbo

# Map to assembly
bbmap.sh ref="$ASM" in=clean_R1.fq.gz in2=clean_R2.fq.gz out=mapped.sam
samtools view -bS mapped.sam | samtools sort -o mapped.bam
samtools index mapped.bam

# Depth per contig for binning
jgi_summarize_bam_contig_depths --outputDepth depth.txt mapped.bam
echo "QC+map done: clean_* fastq, mapped.bam, depth.txt"
```

## `scripts/assemble_spades.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
R1=${1:-clean_R1.fq.gz}
R2=${2:-clean_R2.fq.gz}
OUT=${3:-spades_out}
spades.py -1 "$R1" -2 "$R2" -o "$OUT" --careful -t 4 -m 8
echo "SPAdes assembly at $OUT/contigs.fasta"
```

## `scripts/assemble_tadpole.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
R1=${1:-clean_R1.fq.gz}
R2=${2:-clean_R2.fq.gz}
tadpole.sh in="$R1" in2="$R2" out=contigs_tadpole.fna mode=contig
echo "Tadpole contigs: contigs_tadpole.fna"
```

## `scripts/bin_metabat2.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
ASM=${1:-spades_out/contigs.fasta}
DEPTH=${2:-depth.txt}
outdir=bins_metabat2 && mkdir -p "$outdir"
metabat2 -i "$ASM" -a "$DEPTH" -o "$outdir/bin"
echo "MetaBAT2 bins in $outdir/"
```

## `scripts/bin_semibin2.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
ASM=${1:-spades_out/contigs.fasta}
R1=${2:-clean_R1.fq.gz}
R2=${3:-clean_R2.fq.gz}
outdir=semibin2_out
SemiBin2 single_easy_bin -i "$ASM" -r "$R1" "$R2" -o "$outdir"
echo "SemiBin2 output in $outdir/"
```

## `scripts/cluster_mmseqs2.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
FAA=${1:-data/examples/example.faa}
mmseqs createdb "$FAA" db
mmseqs linclust db db_clu tmp --min-seq-id 0.9 -c 0.8 --cov-mode 1
mmseqs createtsv db db db_clu clusters.tsv
echo "clusters.tsv written"
```

## `scripts/cluster_cdhit.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
FAA=${1:-data/examples/example.faa}
cd-hit -i "$FAA" -o proteins90.faa -c 0.9 -n 5 -T 4 -M 8000
echo "CD-HIT clusters at proteins90.faa"
```

## `scripts/cluster_diamond.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
FAA=${1:-data/examples/example.faa}
diamond makedb --in "$FAA" -d prot
diamond cluster --db prot --out clusters_diamond.tsv --linclust --min-id 0.9
echo "DIAMOND clusters at clusters_diamond.tsv"
```

## `scripts/align_mafft.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
FAA=${1:-data/examples/example.faa}
ALN=aln.faa
mafft --auto "$FAA" > "$ALN"
trimal -in "$ALN" -out aln.trim.faa -automated1
echo "Alignment at $ALN ; Trimmed at aln.trim.faa"
```

## `scripts/tree_iqtree.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
ALN=${1:-aln.trim.faa}
iqtree2 -s "$ALN" -m MFP -B 1000 -T AUTO
echo "IQ-TREE outputs *.iqtree *.treefile etc."
```

## `scripts/tree_fasttree.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
ALN=${1:-aln.trim.faa}
FastTree -wag -gamma "$ALN" > tree.nwk
echo "FastTree wrote tree.nwk"
```

## `scripts/demo_all.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
bash scripts/make_mock_reads.sh
bash scripts/qc_map.sh
bash scripts/assemble_spades.sh
bash scripts/bin_metabat2.sh
python scripts/normalize_headers.py -i data/examples/example.faa -o example.norm.faa --genome-id DEMO
bash scripts/align_mafft.sh example.norm.faa
bash scripts/tree_iqtree.sh aln.trim.faa
bash scripts/cluster_mmseqs2.sh example.norm.faa
echo "Demo finished."
```

Make scripts executable:

```bash
chmod +x scripts/*.sh
```

---

# 6) Minimal Python wrappers (call CLIs safely)

## `python/wrappers/diamond.py`

```python
import subprocess, shlex, pathlib

def run(cmd: str):
    print(f"[diamond] {cmd}")
    subprocess.run(shlex.split(cmd), check=True)

def makedb(faa: str, db: str = "prot"):
    run(f"diamond makedb --in {faa} -d {db}")

def cluster(db: str = "prot", out: str = "clusters.tsv", min_id=0.9):
    run(f"diamond cluster --db {db} --out {out} --linclust --min-id {min_id}")
```

## `python/wrappers/mafft.py`

```python
import subprocess, shlex
def align(in_faa: str, out_faa="aln.faa", mode="--auto"):
    cmd=f"mafft {mode} {in_faa}"
    print(f"[mafft] {cmd} > {out_faa}")
    with open(out_faa,"w") as w:
        subprocess.run(shlex.split(cmd), check=True, stdout=w)
    return out_faa
```

## `python/wrappers/trimal.py`

```python
import subprocess, shlex
def automated(in_aln: str, out_aln="aln.trim.faa"):
    subprocess.run(shlex.split(f"trimal -in {in_aln} -out {out_aln} -automated1"), check=True)
    return out_aln
```

## `python/wrappers/iqtree.py`

```python
import subprocess, shlex
def iqtree2(in_aln: str, threads="AUTO"):
    subprocess.run(shlex.split(f"iqtree2 -s {in_aln} -m MFP -B 1000 -T {threads}"), check=True)
```

## `python/wrappers/mmseqs.py`

```python
import subprocess, shlex, tempfile, os
def linclust(faa: str, out_tsv="clusters.tsv", min_id=0.9, cov=0.8):
    tmp = tempfile.mkdtemp()
    for cmd in [
        f"mmseqs createdb {faa} db",
        f"mmseqs linclust db db_clu {tmp} --min-seq-id {min_id} -c {cov} --cov-mode 1",
        f"mmseqs createtsv db db db_clu {out_tsv}",
    ]:
        subprocess.run(shlex.split(cmd), check=True)
    return out_tsv
```

---

# 7) Docs (short + specific commands)

## `docs/00_fasta_formats.md`

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

## `docs/01_reads_and_bbtools.md`

* **QC**: trim adapters + low-quality tails:

  ```bash
  bbduk.sh in=R1.fq.gz in2=R2.fq.gz out1=clean_R1.fq.gz out2=clean_R2.fq.gz \
           ref=adapters ktrim=r k=23 mink=11 hdist=1 tpe tbo
  ```
* **Map** and make depths:

  ```bash
  bbmap.sh ref=assembly.fna in=clean_R1.fq.gz in2=clean_R2.fq.gz out=mapped.sam
  samtools sort -o mapped.bam mapped.sam && samtools index mapped.bam
  jgi_summarize_bam_contig_depths --outputDepth depth.txt mapped.bam
  ```
* **Simulate** reads (offline):

  ```bash
  randomreads.sh ref=assembly.fna out1=R1.fq.gz out2=R2.fq.gz len=150 paired coverage=30
  ```
* **BBTools in Docker** (optional, no local install):

  ```bash
  docker run --rm -v $PWD:/work -w /work staphb/bbtools:latest bbmap.sh --version
  ```

## `docs/02_taxonomy_basics.md`

* **GTDB**: genome-based bacterial/archaeal taxonomy; use **GTDB-Tk**:

  ```bash
  gtdbtk classify_wf --genome_dir bins/ --out_dir gtdbtk_out --extension fa --cpus 8
  ```
* **SeqCode**: sequence-based nomenclature framework (overview/paper).
* **QuickClade** (BBTools): fast k-mer taxonomy for contigs.
* **TaxonKit**: NCBI TaxID utilities:

  ```bash
  echo 562 | taxonkit lineage | taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s}"
  ```

## `docs/03_binning.md`

* **MetaBAT2** (coverage + tetranucleotide):

  ```bash
  metabat2 -i assembly.fna -a depth.txt -o bins/bin
  ```
* **SemiBin2** (self-supervised):

  ```bash
  SemiBin2 single_easy_bin -i assembly.fna -r clean_R1.fq.gz clean_R2.fq.gz -o semibin2_out
  ```
* **QuickBin** (BBTools):

  ```bash
  quickbin.sh in=assembly.fna out=bins_quickbin/
  ```

## `docs/04_assembly.md`

* **SPAdes** (Illumina PE):

  ```bash
  spades.py -1 clean_R1.fq.gz -2 clean_R2.fq.gz -o spades_out --careful -t 8 -m 32
  ```
* **Tadpole**:

  ```bash
  tadpole.sh in=clean_R1.fq.gz in2=clean_R2.fq.gz out=contigs_tadpole.fna mode=contig
  ```

## `docs/05_clustering.md`

* **MMseqs2 Linclust**:

  ```bash
  mmseqs createdb proteins.faa db
  mmseqs linclust db db_clu tmp --min-seq-id 0.9 -c 0.8 --cov-mode 1
  mmseqs createtsv db db db_clu clusters.tsv
  ```
* **CD-HIT**:

  ```bash
  cd-hit -i proteins.faa -o proteins90.faa -c 0.9 -n 5 -T 8 -M 32000
  ```
* **DIAMOND cluster**:

  ```bash
  diamond makedb --in proteins.faa -d prot
  diamond cluster --db prot --out clusters_diamond.tsv --linclust --min-id 0.9
  ```
* **PhyloDM** (if you add it later): tree → distance matrix.

## `docs/06_phylogeny_taxonomy_workflow.md`

* Align → trim → infer:

  ```bash
  mafft --auto proteins.faa > aln.faa
  trimal -in aln.faa -out aln.trim.faa -automated1
  iqtree2 -s aln.trim.faa -m MFP -B 1000 -T AUTO
  # or very fast:
  FastTree -wag -gamma aln.trim.faa > tree.nwk
  ```

---

# 8) README.md (paste)

## `README.md`

````markdown
# nelli-getting-started

Hands-on tutorial repo for new team members. Shows basics of reads QC, assembly, binning, clustering, and phylogeny with short, runnable examples.

## Pick your environment
- **uv** (Python only; fast): `uv sync -p 3.11 && uv run jupyter lab`
- **pixi** (Python + CLI bio tools): `pixi install && pixi shell`

Env files in `envs/`.

## Run the 10-minute demo
```bash
bash scripts/demo_all.sh
````

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

* For small tests we generate **mock reads** with BBTools; no downloads needed.
* Use `pixi` if you want the full CLI stack from Bioconda/conda-forge.
* Use `uv` for Python-only tutorials and notebooks.

````

---

# 9) Small ML example (optional)

## `python/examples/mini_ml_pipeline.py`
```python
import pandas as pd, polars as pl
from sklearn.ensemble import RandomForestClassifier

# toy: build fake features from clusters.tsv (MMseqs2)
tsv = "clusters.tsv"
df = pd.read_csv(tsv, sep="\t", header=None, names=["q","t","clu"])
# dummy labels by cluster parity
df["y"] = (df["clu"].astype(str).str[-1].astype(int) % 2).astype(int)
X = pd.get_dummies(df["clu"])
clf = RandomForestClassifier(n_estimators=50, random_state=0).fit(X, df["y"])
print("Model trained; classes:", clf.classes_)
````

---

# 10) Where header renaming *usually* bites (and how we handle it)

* **RefSeq/GenBank contigs**: `>NZ_CP012345.1 Escherichia ...` → `contig_id=NZ_CP012345.1`
* **Proteins**: `>WP_123456789.1 ...` → `protein_id=WP_123456789.1`
* **ENA**: `>A01234.1 ...` → first token still works.
* **Your genome/sample ID**: pass `--genome-id`, or let the script use filename stem.
* Resulting headers are minimal and machine-friendly, and downstream scripts rely only on `genome_id|id`.

---

That’s everything needed to **complement** the first answer: this one is the **concrete repo drop-in** with runnable scripts and the **header-normalization** workflow baked in. If you want, I can also add a one-file **Makefile** to orchestrate each step with targets (`mock`, `qc`, `assemble`, `bin`, `cluster`, `tree`).

Sweet—here’s a clean **Makefile** that orchestrates everything we laid down (mock reads → QC/map → assembly → binning → clustering → phylogeny → header normalization), plus a short audit to ensure all filenames/targets line up with the earlier repo plan.

---

# Makefile (drop into repo root as `Makefile`)

```make
# ===== nelli-getting-started Makefile =====
# Works with either:
#   - `pixi shell` (preferred for CLI bio tools)
#   - or a host env that already has the tools on PATH.
# Tips:
#   - Run `make help` to see targets.
#   - Use `-j` only for independent targets (most targets are sequential by design).

SHELL := /usr/bin/env bash
.ONESHELL:
.SHELLFLAGS := -euo pipefail -c
MAKEFLAGS += --no-builtin-rules

# ---------------- Paths / files ----------------
DATA_EX       := data/examples
DATA_MOCK     := data/mock
SCRIPTS       := scripts
PY_SCRIPTS    := python/wrappers
ASM_SPADES    := spades_out/contigs.fasta
ASM_TADPOLE   := contigs_tadpole.fna
CLEAN_R1      := clean_R1.fq.gz
CLEAN_R2      := clean_R2.fq.gz
MAPPED_BAM    := mapped.bam
DEPTH_TXT     := depth.txt
BINS_MB2_DIR  := bins_metabat2
BINS_SB2_DIR  := semibin2_out
FAA_EXAMPLE   := $(DATA_EX)/example.faa
FNA_EXAMPLE   := $(DATA_EX)/example.fna
FAA_NORM      := example.norm.faa
ALN           := aln.faa
ALN_TRIM      := aln.trim.faa
TREE_NWK      := tree.nwk
CLUST_TSV     := clusters.tsv
DIAMOND_TSV   := clusters_diamond.tsv

# ---------------- Helper macros ----------------
define need
	@command -v $(1) >/dev/null 2>&1 || { echo "ERROR: Missing tool '$(1)' on PATH."; exit 127; }
endef

# ---------------- Phony targets ----------------
.PHONY: help env-check all clean clean-hard \
        mock qc map depth assemble-spades assemble-tadpole \
        bin-metabat2 bin-semibin2 \
        cluster-mmseqs2 cluster-cdhit cluster-diamond \
        align trim tree-iqtree tree-fasttree \
        normalize demo

help:
	@echo "Targets:"
	@echo "  env-check         Validate required tools on PATH"
	@echo "  mock              Generate tiny paired-end reads from example.fna (BBTools)"
	@echo "  qc                QC reads (bbduk)"
	@echo "  map               Map reads to assembly (bbmap) -> BAM"
	@echo "  depth             Per-contig depth (jgi_summarize_bam_contig_depths)"
	@echo "  assemble-spades   Assemble with SPAdes"
	@echo "  assemble-tadpole  Assemble with Tadpole (BBTools)"
	@echo "  bin-metabat2      Bin with MetaBAT2"
	@echo "  bin-semibin2      Bin with SemiBin2"
	@echo "  cluster-mmseqs2   Cluster proteins with MMseqs2 Linclust"
	@echo "  cluster-cdhit     Cluster proteins with CD-HIT"
	@echo "  cluster-diamond   Cluster proteins with DIAMOND"
	@echo "  align             Multiple sequence alignment with MAFFT"
	@echo "  trim              Trim alignment with trimAl"
	@echo "  tree-iqtree       ML tree with IQ-TREE"
	@echo "  tree-fasttree     Fast approx ML tree with FastTree"
	@echo "  normalize         Normalize FASTA headers to GENOME|ID"
	@echo "  demo              End-to-end: mock→qc→map→spades→bin→normalize→align→iqtree→mmseqs2"
	@echo "  clean             Remove generated intermediates (keeps example data)"
	@echo "  clean-hard        Remove everything generated"

# Validate a minimal toolset for the default demo path
env-check:
	$(call need,randomreads.sh)
	$(call need,bbduk.sh)
	$(call need,bbmap.sh)
	$(call need,samtools)
	$(call need,jgi_summarize_bam_contig_depths)
	$(call need,spades.py)
	$(call need,metabat2)
	$(call need,mafft)
	$(call need,trimal)
	$(call need,iqtree2)
	$(call need,mmseqs)
	$(call need,python)

# ----- Data generation -----
mock: $(DATA_MOCK)/mock_R1.fq.gz $(DATA_MOCK)/mock_R2.fq.gz
$(DATA_MOCK)/mock_R1.fq.gz $(DATA_MOCK)/mock_R2.fq.gz: $(FNA_EXAMPLE)
	mkdir -p $(DATA_MOCK)
	$(SCRIPTS)/make_mock_reads.sh

# ----- QC / Mapping / Depth -----
qc: $(CLEAN_R1) $(CLEAN_R2)
$(CLEAN_R1) $(CLEAN_R2): $(DATA_MOCK)/mock_R1.fq.gz $(DATA_MOCK)/mock_R2.fq.gz
	$(SCRIPTS)/qc_map.sh $(DATA_MOCK)/mock_R1.fq.gz $(DATA_MOCK)/mock_R2.fq.gz $(FNA_EXAMPLE)

map: $(MAPPED_BAM)
$(MAPPED_BAM): $(CLEAN_R1) $(CLEAN_R2) $(FNA_EXAMPLE)
	$(SCRIPTS)/qc_map.sh $(CLEAN_R1) $(CLEAN_R2) $(FNA_EXAMPLE)

depth: $(DEPTH_TXT)
$(DEPTH_TXT): $(MAPPED_BAM)
	jgi_summarize_bam_contig_depths --outputDepth $(DEPTH_TXT) $(MAPPED_BAM)

# ----- Assembly -----
assemble-spades: $(ASM_SPADES)
$(ASM_SPADES): $(CLEAN_R1) $(CLEAN_R2)
	$(SCRIPTS)/assemble_spades.sh $(CLEAN_R1) $(CLEAN_R2)
	test -s $(ASM_SPADES)

assemble-tadpole: $(ASM_TADPOLE)
$(ASM_TADPOLE): $(CLEAN_R1) $(CLEAN_R2)
	$(SCRIPTS)/assemble_tadpole.sh $(CLEAN_R1) $(CLEAN_R2)
	test -s $(ASM_TADPOLE)

# ----- Binning -----
bin-metabat2: $(BINS_MB2_DIR)
$(BINS_MB2_DIR): $(ASM_SPADES) $(DEPTH_TXT)
	$(SCRIPTS)/bin_metabat2.sh $(ASM_SPADES) $(DEPTH_TXT)

bin-semibin2: $(BINS_SB2_DIR)
$(BINS_SB2_DIR): $(ASM_SPADES) $(CLEAN_R1) $(CLEAN_R2)
	$(SCRIPTS)/bin_semibin2.sh $(ASM_SPADES) $(CLEAN_R1) $(CLEAN_R2)

# ----- Clustering -----
cluster-mmseqs2: $(CLUST_TSV)
$(CLUST_TSV): $(FAA_EXAMPLE)
	$(SCRIPTS)/cluster_mmseqs2.sh $(FAA_EXAMPLE)

cluster-cdhit: proteins90.faa
proteins90.faa: $(FAA_EXAMPLE)
	$(SCRIPTS)/cluster_cdhit.sh $(FAA_EXAMPLE)

cluster-diamond: $(DIAMOND_TSV)
$(DIAMOND_TSV): $(FAA_EXAMPLE)
	$(SCRIPTS)/cluster_diamond.sh $(FAA_EXAMPLE)

# ----- Alignment / Trees -----
align: $(ALN)
$(ALN): $(FAA_NORM)
	$(SCRIPTS)/align_mafft.sh $(FAA_NORM)

trim: $(ALN_TRIM)
$(ALN_TRIM): $(ALN)
	trimal -in $(ALN) -out $(ALN_TRIM) -automated1

tree-iqtree: $(ALN_TRIM)
	$(SCRIPTS)/tree_iqtree.sh $(ALN_TRIM)

tree-fasttree: $(ALN_TRIM)
	$(SCRIPTS)/tree_fasttree.sh $(ALN_TRIM)

# ----- Header normalization -----
normalize: $(FAA_NORM)
$(FAA_NORM): $(FAA_EXAMPLE)
	python $(SCRIPTS)/normalize_headers.py -i $(FAA_EXAMPLE) -o $(FAA_NORM) --genome-id DEMO

# ----- End-to-end demo -----
demo: env-check mock qc assemble-spades bin-metabat2 normalize align tree-iqtree cluster-mmseqs2
	@echo "Demo complete."
	@echo "Outputs:"
	@echo "  - Assembly: $(ASM_SPADES)"
	@echo "  - Bins:     $(BINS_MB2_DIR)"
	@echo "  - Align:    $(ALN_TRIM)"
	@echo "  - Tree:     *.treefile (IQ-TREE)"
	@echo "  - Clusters: $(CLUST_TSV)"

# ----- Cleaning -----
clean:
	rm -f $(CLEAN_R1) $(CLEAN_R2) mapped.sam $(MAPPED_BAM) $(MAPPED_BAM).bai $(DEPTH_TXT) \
	      $(FAA_NORM) $(ALN) $(ALN_TRIM) $(TREE_NWK) $(CLUST_TSV) $(DIAMOND_TSV)
	rm -rf *.iqtree *.treefile *.log
	@echo "Light clean done."

clean-hard: clean
	rm -rf $(DATA_MOCK) spades_out $(BINS_MB2_DIR) $(BINS_SB2_DIR) tmp db db_clu
	@echo "Hard clean done."
```

---

## How to use it

* From **pixi**:

  ```
  pixi install
  pixi run demo   # because tasks.demo maps to bash scripts/demo_all.sh; or just `make demo`
  ```

  Or, just `pixi shell` then `make demo`.

* From a **host env** (tools already on PATH):

  ```
  make demo
  ```

---

## Sync & compatibility audit (quick checks)

1. **Directory names & scripts**

   * Matches previous answers: `scripts/*` names are identical; example data under `data/examples/` is the same (`example.fna`, `example.faa`).
   * The Makefile calls **exactly** the scripts we provided: `make_mock_reads.sh`, `qc_map.sh`, `assemble_spades.sh`, `assemble_tadpole.sh`, `bin_metabat2.sh`, `bin_semibin2.sh`, `cluster_mmseqs2.sh`, `cluster_cdhit.sh`, `cluster_diamond.sh`, `align_mafft.sh`, `tree_iqtree.sh`, `tree_fasttree.sh`, `normalize_headers.py`. ✔️

2. **Header normalization**

   * The Makefile wires `normalize` → `example.norm.faa` using `normalize_headers.py` with `--genome-id DEMO`.
   * Downstream alignment/trees use the normalized FASTA (`align` depends on `example.norm.faa`). ✔️

3. **Tool expectations**

   * `env-check` verifies a minimal toolset (BBTools, samtools, SPAdes, MetaBAT2, MAFFT, trimAl, IQ-TREE, MMseqs2, Python).
   * If running under **pixi**, these come from `envs/pixi.toml`; if using Docker for BBTools, you can either skip `env-check` or swap `randomreads.sh/bbduk.sh/bbmap.sh` with `docker run ... staphb/bbtools:latest ...` in your local fork. (Left simple here to avoid Docker flags in Makefile.) ✔️

4. **Reproducibility**

   * **pixi**: conda/bioconda stack (CLI + Python).
   * **uv**: Python stack only; Makefile targets that require CLI tools assume you’re in a pixi (or equivalent) shell. This is stated in the comments and README. ✔️

5. **Docs coverage**

   * FASTA conventions & header normalization, reads+BBTools (incl. Tadpole), taxonomy (GTDB, GTDB-Tk, SeqCode, QuickClade, TaxonKit), binning (MetaBAT2, SemiBin2, QuickBin), assembly (SPAdes, Tadpole), clustering (MMseqs2, CD-HIT, DIAMOND), phylogeny (MAFFT/trimAl/IQ-TREE/FastTree).
   * All appear with short runnable commands and match the script names. ✔️

6. **NCBI/RefSeq header quirks**

   * The Python normalizer takes the **first token** (pre-space) for `{contig_id|protein_id}` and prefixes your `--genome-id` (or input filename stem). That covers common RefSeq/GenBank/ENA patterns and typical downloaded examples. ✔️

7. **Small demo**

   * Fully offline using **BBTools** `randomreads.sh` to generate the paired-end example; this avoids brittle external URLs and keeps the demo < a minute on a laptop. ✔️

---

If you want, I can also add a tiny **`Makefile.docker`** variant where BBTools steps are executed via `docker run staphb/bbtools:latest` so newcomers don’t install Java/BBMap locally.

