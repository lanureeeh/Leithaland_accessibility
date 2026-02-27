# Contributing

## Naming conventions

- **Destinations:** Use `kindergartens`, `schools`, `pt_stops` (not "kindergarden")
- **Networks:** `bike_network`, `walk_network`
- **Accessibility layers:** `{mode}_{destination}` e.g. `walk_kindergartens`, `bike_pt_stops`
- **GeoJSON outputs:** Generated in `docs/data/`; filenames match layer IDs

## Data locations

| Content              | Path                              |
|----------------------|-----------------------------------|
| Boundaries           | `data/boundaries/`                |
| Destinations         | `data/destinations/`              |
| Networks             | `data/networks/`                  |
| Gridded results      | `results/grids/no_buffers/`       |
| Point results        | `results/points/`                 |
| Web map data         | `docs/data/*.geojson` (generated) |

## Workflow for map updates

1. Update source data or run analysis (GeoPackage in `data/`, `results/grids/`, or `results/points/`).
2. Regenerate GeoJSON: `python scripts/convert_gpkg_to_geojson.py`
3. Test locally: `python -m http.server 8000` → http://localhost:8000/docs/
4. Commit and push.

## Adding new destinations or modes

1. Add source GeoPackage to the appropriate folder.
2. Update `scripts/convert_gpkg_to_geojson.py` (and `.sh` if used).
3. Add layer loading and controls in `docs/index.html`.
