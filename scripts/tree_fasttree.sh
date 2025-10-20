#!/usr/bin/env bash
set -euo pipefail
ALN=${1:-aln.trim.faa}
FastTree -wag -gamma "$ALN" > tree.nwk
echo "FastTree wrote tree.nwk"

