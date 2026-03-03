# Leithaland Accessibility Map

Interactive map of travel times to **Public Transit Stops**, **schools**, and **kindergartens** by walking and cycling in the Leithaland KLAR! region (Austria).

> This folder is part of the **Mobility** project. Run scripts from the parent directory (`Mobility/`).

## Live map

**https://lanureeeh.github.io/Leithaland_accessibility/**

## Data pipeline

| Step | Command | Output |
|------|---------|--------|
| 1. Extract OSM networks | `python extract_networks.py` (from `Mobility/`) | `data/networks/walk_network.gpkg`, `bike_network.gpkg` |
| 2. Compute travel times | `python snap_origins_and_destinations.py` (from `Mobility/`) | `results/points/*.gpkg`, `results/grids/no_buffers/*.gpkg` |
| 3. Convert for web map | `python scripts/convert_gpkg_to_geojson.py` (from `Leithaland/`) | `docs/data/*.geojson` |

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

- **Python 3.10+** with dependencies from parent project: `pip install -r ../requirements.txt`
- **geopandas** for GeoJSON conversion
- **GDAL** (`ogr2ogr`) optional – for shell script alternative
