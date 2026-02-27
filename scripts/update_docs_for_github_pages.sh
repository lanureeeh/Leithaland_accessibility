#!/bin/bash
# Regenerate GeoJSON from GeoPackage and prepare docs/ for GitHub Pages.
# Run from project root. Use after updating source data or analysis results.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"
python3 scripts/convert_gpkg_to_geojson.py
echo "docs/ is ready for commit. Push to update GitHub Pages."
