#!/usr/bin/env bash
set -euo pipefail
FAA=${1:-data/examples/example.faa}
cd-hit -i "$FAA" -o proteins90.faa -c 0.9 -n 5 -T 4 -M 8000
echo "CD-HIT clusters at proteins90.faa"

