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

