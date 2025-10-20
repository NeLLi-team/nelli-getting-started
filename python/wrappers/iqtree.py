import shlex
import subprocess


def iqtree2(in_aln: str, threads: str = "AUTO") -> None:
    subprocess.run(
        shlex.split(f"iqtree2 -s {in_aln} -m MFP -B 1000 -T {threads}"),
        check=True,
    )

