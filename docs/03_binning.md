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

