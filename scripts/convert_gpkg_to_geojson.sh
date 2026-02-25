#!/bin/bash
# Convert GeoPackage layers to GeoJSON using ogr2ogr (GDAL).
# Run from Leithaland project root.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OUT_DIR="$PROJECT_ROOT/leaflet/leithaland-accessibility-map/data"
mkdir -p "$OUT_DIR"

# Gridded layers (unbuffered)
for f in walk_pt_stops walk_schools walk_kindergarden bike_pt_stops bike_schools bike_kindergarden; do
  src="$PROJECT_ROOT/results/gridded/unbuffered/${f}.gpkg"
  dst="$OUT_DIR/${f}.geojson"
  if [ -f "$src" ]; then
    ogr2ogr -f GeoJSON -t_srs EPSG:4326 "$dst" "$src"
    echo "  OK: $f"
  else
    echo "  Skip: $f (not found)"
  fi
done

# Networks (use first layer; OSMnx often uses "edges")
for n in bike_network walk_network; do
  src="$PROJECT_ROOT/data/${n}.gpkg"
  dst="$OUT_DIR/${n}.geojson"
  if [ -f "$src" ]; then
    ogr2ogr -f GeoJSON -t_srs EPSG:4326 "$dst" "$src"
    echo "  OK: $n"
  else
    echo "  Skip: $n (not found)"
  fi
done

# Destinations
for d in pt_stops kindergartens schools; do
  src="$PROJECT_ROOT/data/destination_layers/${d}.gpkg"
  dst="$OUT_DIR/${d}.geojson"
  if [ -f "$src" ]; then
    ogr2ogr -f GeoJSON -t_srs EPSG:4326 "$dst" "$src"
    echo "  OK: $d"
  else
    echo "  Skip: $d (not found)"
  fi
done

# Boundary
if [ -f "$PROJECT_ROOT/data/leithaland_4326.gpkg" ]; then
  ogr2ogr -f GeoJSON -t_srs EPSG:4326 "$OUT_DIR/boundary.geojson" "$PROJECT_ROOT/data/leithaland_4326.gpkg"
  echo "  OK: boundary"
else
  echo "  Skip: boundary (not found)"
fi

echo "Done. Output: $OUT_DIR"
