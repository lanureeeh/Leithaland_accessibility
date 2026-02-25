#!/bin/bash
# After running convert_gpkg_to_geojson.py, copy data to docs/ for GitHub Pages.
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SRC="$PROJECT_ROOT/leaflet/leithaland-accessibility-map/data"
DST="$PROJECT_ROOT/docs/data"
if [ ! -d "$SRC" ]; then
  echo "Run convert_gpkg_to_geojson.py first."
  exit 1
fi
cp "$SRC"/*.geojson "$DST/"
cp "$PROJECT_ROOT/leaflet/leithaland-accessibility-map/leaflet_map.html" "$PROJECT_ROOT/docs/index.html"
echo "Updated docs/ for GitHub Pages."
