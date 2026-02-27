#!/bin/bash
# Convert GeoPackage layers to GeoJSON using ogr2ogr (GDAL).
# Run from project root. Output: docs/data/*.geojson

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OUT_DIR="$PROJECT_ROOT/docs/data"
mkdir -p "$OUT_DIR"

# Gridded layers. Source files use "kindergarden" (legacy); output uses "kindergartens"
for src_name in walk_pt_stops walk_schools walk_kindergarden bike_pt_stops bike_schools bike_kindergarden; do
  case "$src_name" in
    walk_kindergarden) out_name="walk_kindergartens" ;;
    bike_kindergarden) out_name="bike_kindergartens" ;;
    *) out_name="$src_name" ;;
  esac
  src="$PROJECT_ROOT/results/grids/no_buffers/${src_name}.gpkg"
  dst="$OUT_DIR/${out_name}.geojson"
  if [ -f "$src" ]; then
    ogr2ogr -f GeoJSON -t_srs EPSG:4326 "$dst" "$src"
    echo "  OK: $src_name -> $out_name"
  else
    echo "  Skip: $src_name (not found)"
  fi
done

# Networks
for n in bike_network walk_network; do
  src="$PROJECT_ROOT/data/networks/${n}.gpkg"
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
  src="$PROJECT_ROOT/data/destinations/${d}.gpkg"
  dst="$OUT_DIR/${d}.geojson"
  if [ -f "$src" ]; then
    ogr2ogr -f GeoJSON -t_srs EPSG:4326 "$dst" "$src"
    echo "  OK: $d"
  else
    echo "  Skip: $d (not found)"
  fi
done

# Boundary
if [ -f "$PROJECT_ROOT/data/boundaries/leithaland_4326.gpkg" ]; then
  ogr2ogr -f GeoJSON -t_srs EPSG:4326 "$OUT_DIR/boundary.geojson" "$PROJECT_ROOT/data/boundaries/leithaland_4326.gpkg"
  echo "  OK: boundary"
else
  echo "  Skip: boundary (not found)"
fi

echo "Done. Output: $OUT_DIR"
