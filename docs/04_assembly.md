* **SPAdes** (Illumina PE):

  ```bash
  spades.py -1 clean_R1.fq.gz -2 clean_R2.fq.gz -o spades_out --careful -t 8 -m 32
  ```
* **Tadpole**:

  ```bash
  tadpole.sh in=clean_R1.fq.gz in2=clean_R2.fq.gz out=contigs_tadpole.fna mode=contig
  ```

