* Align → trim → infer:

  ```bash
  mafft --auto proteins.faa > aln.faa
  trimal -in aln.faa -out aln.trim.faa -automated1
  iqtree2 -s aln.trim.faa -m MFP -B 1000 -T AUTO
  # or very fast:
  FastTree -wag -gamma aln.trim.faa > tree.nwk
  ```

