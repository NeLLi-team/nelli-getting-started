import pathlib
import shlex
import subprocess


def _run(cmd: str) -> None:
    print(f"[diamond] {cmd}")
    subprocess.run(shlex.split(cmd), check=True)


def makedb(faa: str, db: str = "prot") -> None:
    _run(f"diamond makedb --in {faa} -d {db}")


def cluster(db: str = "prot", out: str = "clusters.tsv", min_id: float = 0.9) -> None:
    _run(f"diamond cluster --db {db} --out {out} --linclust --min-id {min_id}")

