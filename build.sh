#!/usr/bin/env bash
# Reproducible build with the TeX Live version matching the originals (MiKTeX, pdfTeX 1.40.16 → TeX Live 2015).
# Requires podman (or docker: export ENGINE=docker).
#   ./build.sh          paper (as submitted, v1.0) → build/iv17-submission-cr.pdf
#   ./build.sh slides   talk                       → build-slides/iv-mixed.pdf
set -euo pipefail
cd "$(dirname "$0")"
ENGINE=${ENGINE:-podman}
dir=src out=build main=iv17-submission-cr tl=TL2015
case ${1:-} in
  slides) dir=slides out=build-slides main=iv-mixed ;;
esac
mkdir -p "$out"
"$ENGINE" run --rm -e openout_any=a -v "$PWD/$dir:/src:ro,Z" -v "$PWD/$out:/out:Z" -w /src \
  "docker.io/texlive/texlive:$tl-historic" latexmk -pdf -interaction=nonstopmode -outdir=/out "$main.tex"
