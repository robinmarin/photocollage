#!/usr/bin/env bash
# make_8up_4R_im7.sh  ─ 8-up on 4R, zero inner margin
# Usage: ./make_8up_4R_im7.sh photo.jpg [out.jpg]

set -e
in="$1"                         || { echo "Give me a file"; exit 1; }
out="${2:-${in%.*}_4R.jpg}"

dpi=300
cell_w=$((6*dpi/4))             # 450 px
canvas_w=$((6*dpi))             # 1800 px
canvas_h=$((4*dpi))             # 1200 px

tmp="$(mktemp).jpg"
sheet="$(mktemp).png"

# scale once
magick "$in" -resize "${cell_w}x" "$tmp"

# 8-up, 4×2 grid, no gaps
magick montage "$tmp" "$tmp" "$tmp" "$tmp" "$tmp" "$tmp" "$tmp" "$tmp" \
               -tile 4x2 -geometry +0+0 -background none "$sheet"

# centre on 6×4" canvas
magick "$sheet" -gravity center -background white \
       -extent "${canvas_w}x${canvas_h}" \
       -units PixelsPerInch -density "$dpi" -quality 95 "$out"

rm -f "$tmp" "$sheet"
echo "Saved $out"

