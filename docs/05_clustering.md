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

