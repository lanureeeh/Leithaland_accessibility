# Leithaland Accessibility Map

Interactive map of travel times to **Public Transit Stops**, **schools**, and **kindergartens** by walking and cycling in the Leithaland KLAR! region (Austria).

## Live map

**https://lanureeeh.github.io/Leithaland_accessibility/**

## Project structure

```
Leithaland/
├── data/               # Source datasets
│   ├── boundaries/     # Study area boundary (leithaland_4326, leithaland_polygons)
│   ├── destinations/   # kindergartens, schools, pt_stops
│   ├── grids/          # Origin grids (50m, 100m)
│   ├── networks/       # bike_network, walk_network
│   ├── osm_networks/   # Raw OSM network data
│   └── transit/        # Transit stops
├── results/            # Accessibility analysis outputs
│   ├── grids/          # Rasterised travel-time polygons
│   │   ├── no_buffers/ # Source for web map (walk_*, bike_*)
│   │   └── with_buffers/
│   └── points/         # Point-based accessibility
├── docs/               # Web map (GitHub Pages)
│   ├── data/           # GeoJSON (generated from GeoPackage)
│   └── index.html      # Leaflet map
├── scripts/            # Conversion and deployment
└── archive/            # Archived projects
```

## Local development

### 1. Convert GeoPackage to GeoJSON

Browsers cannot load GeoPackage directly. From the project root:

```bash
python scripts/convert_gpkg_to_geojson.py
```

Or with GDAL: `bash scripts/convert_gpkg_to_geojson.sh`

### 2. Run a local server

```bash
python -m http.server 8000
```

### 3. Open the map

- **http://localhost:8000/docs/** (or http://localhost:8000/docs/index.html)

## Deploying to GitHub Pages

1. Push the repo:
   ```bash
   git push origin main
   ```

2. On GitHub: **Settings** → **Pages** → **Source**: Deploy from branch → `main` → `/docs` → Save.

3. To update after changing data: run `bash scripts/update_docs_for_github_pages.sh`, then commit and push.

## Requirements

- **Python 3** with `geopandas` for conversion: `pip install geopandas`
- Or **GDAL** (`ogr2ogr`) for the shell script alternative
