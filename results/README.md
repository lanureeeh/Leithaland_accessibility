# Results

Accessibility analysis outputs (GeoPackage format).

- **points/:** Point-based accessibility per destination (e.g. `bike_kindergartens.gpkg`)
- **grids/no_buffers/:** Source for web map conversion (walk_*, bike_* layers)
- **grids/with_buffers/:** Buffered gridded polygons

Run `scripts/convert_gpkg_to_geojson.py` to regenerate `docs/data/*.geojson` from `grids/no_buffers/`.
