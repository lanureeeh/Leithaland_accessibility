# Leithaland Accessibility Map

Interactive map of travel times to Public Transit Stops, schools, and kindergartens by walking and cycling in the Leithaland KLAR! region.

## Prerequisites

- Python 3 with `geopandas` installed (`pip install geopandas`)
- A modern web browser

## Step 1: Convert GeoPackage to GeoJSON

Browsers cannot load GeoPackage directly. Run one of these from the **Leithaland project root**:

**Option A (Python + geopandas):**
```bash
cd /path/to/Leithaland
python3 scripts/convert_gpkg_to_geojson.py
```

**Option B (GDAL ogr2ogr):**
```bash
cd /path/to/Leithaland
bash scripts/convert_gpkg_to_geojson.sh
```

This writes GeoJSON files to `leaflet/leithaland-accessibility-map/data/`.

## Step 2: Run a Local Web Server

The map loads data files via HTTP. Open a terminal in the **Leithaland project root** (or in `leaflet/leithaland-accessibility-map`) and start a local server:

```bash
cd /path/to/Leithaland
python3 -m http.server 8000
```

## Step 3: Open the Map

In your browser, go to:

- **From project root:** [http://localhost:8000/leaflet/leithaland-accessibility-map/leaflet_map.html](http://localhost:8000/leaflet/leithaland-accessibility-map/leaflet_map.html)
- **From map folder:** [http://localhost:8000/leaflet_map.html](http://localhost:8000/leaflet_map.html) (if you `cd` into `leithaland-accessibility-map` first, use port 8000 on that folder)

## Layer Controls

- **Accessibility (radio):** Switch between walk/bike × Public Transit Stops / schools / kindergartens
- **Networks:** Toggle walk network (blue) and bike network (green)
- **Destinations:** Toggle Public Transit Stops, kindergartens, schools
- **Boundary:** Toggle study area outline

## Data Sources

- Gridded layers: `results/gridded/unbuffered/*.gpkg`
- Networks: `data/bike_network.gpkg`, `data/walk_network.gpkg`
- Destinations: `data/destination_layers/pt_stops.gpkg`, `kindergartens.gpkg`, `schools.gpkg`
