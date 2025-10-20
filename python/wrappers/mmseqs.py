import os
import shlex
import subprocess
import tempfile


def linclust(faa: str, out_tsv: str = "clusters.tsv", min_id: float = 0.9, cov: float = 0.8) -> str:
    tmp_dir = tempfile.mkdtemp()
    commands = [
        f"mmseqs createdb {faa} db",
        f"mmseqs linclust db db_clu {tmp_dir} --min-seq-id {min_id} -c {cov} --cov-mode 1",
        f"mmseqs createtsv db db db_clu {out_tsv}",
    ]
    for cmd in commands:
        subprocess.run(shlex.split(cmd), check=True)
    return out_tsv

