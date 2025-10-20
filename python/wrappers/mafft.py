import shlex
import subprocess


def align(in_faa: str, out_faa: str = "aln.faa", mode: str = "--auto") -> str:
    cmd = f"mafft {mode} {in_faa}"
    print(f"[mafft] {cmd} > {out_faa}")
    with open(out_faa, "w", encoding="utf-8") as handle:
        subprocess.run(shlex.split(cmd), check=True, stdout=handle)
    return out_faa

