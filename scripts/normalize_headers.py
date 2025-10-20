#!/usr/bin/env python3
import sys
import argparse
import os
from Bio import SeqIO


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Normalize FASTA headers to {genome_id}|{id}"
    )
    parser.add_argument("-i", "--in", dest="inp", required=True, help="input .fna or .faa")
    parser.add_argument("-o", "--out", dest="out", required=True, help="output fasta")
    parser.add_argument(
        "--genome-id",
        dest="gid",
        default=None,
        help="genome/sample ID to prefix (default=filename stem)",
    )
    args = parser.parse_args()

    gid = args.gid or os.path.splitext(os.path.basename(args.inp))[0]
    count = 0
    with open(args.out, "w") as out_file:
        for record in SeqIO.parse(args.inp, "fasta"):
            token = record.id  # SeqIO splits by whitespace; take first token
            record.id = f"{gid}|{token}"
            record.description = ""
            SeqIO.write(record, out_file, "fasta")
            count += 1
    sys.stderr.write(f"Wrote {count} records to {args.out}\n")


if __name__ == "__main__":
    main()

