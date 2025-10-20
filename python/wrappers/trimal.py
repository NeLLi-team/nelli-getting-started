import shlex
import subprocess


def automated(in_aln: str, out_aln: str = "aln.trim.faa") -> str:
    subprocess.run(
        shlex.split(f"trimal -in {in_aln} -out {out_aln} -automated1"),
        check=True,
    )
    return out_aln

