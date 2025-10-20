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

