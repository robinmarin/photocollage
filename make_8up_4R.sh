#!/usr/bin/env bash
# make_passport_4R.sh – 8 Swedish-passport photos on a 4 × 6″ print

set -euo pipefail
in="$1"; out="${2:-${in%.*}_4R.jpg}"

dpi=300
cell_w=414          # 35 mm at 300 dpi
cell_h=531          # 45 mm at 300 dpi
canvas_w=$((6*dpi)) # 1800 px
canvas_h=$((4*dpi)) # 1200 px

# BSD-compatible temp-file creation (adds extension manually)
tmp="$(mktemp -t passphoto).jpg"
sheet="$(mktemp -t passsheet).png"

# 1. Exact 35 × 45 mm crop
magick "$in" -resize "${cell_w}x${cell_h}^" \
             -gravity center -extent "${cell_w}x${cell_h}" "$tmp"

# 2. 4 × 2 grid, zero gaps
magick montage "$tmp" "$tmp" "$tmp" "$tmp" "$tmp" "$tmp" "$tmp" "$tmp" \
               -tile 4x2 -geometry +0+0 -background none "$sheet"

# 3. Centre grid on 6 × 4″ canvas → ≈ 72 px side & 69 px top/bottom margins
magick "$sheet" -gravity center -background white -extent "${canvas_w}x${canvas_h}" \
       -units PixelsPerInch -density "$dpi" -quality 95 "$out"

rm -f "$tmp" "$sheet"
echo "Saved '$out'"
