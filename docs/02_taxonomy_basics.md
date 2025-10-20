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

